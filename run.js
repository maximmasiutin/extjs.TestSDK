import fs from 'fs'
import { resolve } from 'path'
import { performance } from 'perf_hooks'
import playwright from 'playwright'
import terminal from 'terminal-kit'
import { formatDistance } from 'date-fns'
import { createServer } from 'http-server';
import shortuniqueid from "short-unique-id";

const { terminal: term } = terminal

const indent = '  '
const testRunId = (new shortuniqueid({length: 10})).rnd();
const resultsDir = resolve('.', 'results')

if (!fs.existsSync(resultsDir)) {
    fs.mkdirSync(resultsDir)
}

const args = process.argv.slice(2);

let sdkHost = '';
let singleTest = '';
let showPass = false;
let doNotRunWebServer = false;
let disableLeakCheks = false;
let argIndex = 0;
let browsers = ['chromium', 'firefox', 'webkit'];
let toolkits = ['classic', 'modern'];
let separator = ',';

function validateValues(types, providedValues) {
    let validTypes = [];

    providedValues.forEach(function(value) {
        if (types.includes(value)) {
            validTypes.push(value);
        }
    });

    if (validTypes.length === 0) {
        validTypes = types;
    }

    return validTypes;
}

args.forEach(function(arg) {
    switch(arg) {
        case '-sdk-url':
            sdkHost = args[argIndex + 1];
            break;
        case '-single-test':
            singleTest = args[argIndex + 1];
            break;
        case '-no-webserver':
            doNotRunWebServer = (args[argIndex + 1]).split(separator);
            break;
        case '-show-pass':
            showPass = (args[argIndex + 1] === 'true');
            break;
        case '-disable-leak-checks':
            disableLeakCheks = (args[argIndex + 1] === 'true');
            break;
        case '-browsers':
            browsers = validateValues(
                browsers,
                (args[argIndex + 1]).split(separator)
            );
            break;
        case '-toolkits':
            toolkits = validateValues(
                toolkits,
                (args[argIndex + 1]).split(separator)
            );
            break;
    }
    argIndex++;
});

term.clear()
term.white.bold(`Running Unit tests in ${browsers.join(', ')} using ${toolkits.join(', ')}. ⚔️\n`)

const createMessageProcessor = (callback, { browser, showPassed, toolkit } = {}) => {
    const results = []
    const currentSuite = []
    let currentTest = {}
    let isSuitesFirstTest = true
    let lastTestStartTime
    const suffix = `(${toolkit}-${browser})`

    return (msg) => {
        const { type, name, message, plan, topSuite } = msg

        const suite = currentSuite.join(' / ')
        if (type === 'message') {
            term.white(`${suffix} ${msg.text}\n`);
        } else if (type === 'testStarted') {
            lastTestStartTime = performance.now()
            currentTest = { suite: Array.from(currentSuite), name, passed: true, browser, toolkit }

            if (showPassed && isSuitesFirstTest) {
                term.white(`📙 ${suite}\n`)
                isSuitesFirstTest = false
            }

            results.push(currentTest)
        } else if (type === 'testSuiteStarted') {
            currentSuite.push(name)
        } else if (type === 'testFinished') {
            const { passed, message: errorMessage } = currentTest
            const end = performance.now()
            const time = formatDistance(lastTestStartTime, end)

            currentTest = Object.assign(currentTest, { time })

            if (showPassed && passed) {
                term.white(indent).green(`✔️ Passed: ${name} ${suffix}\n`)
            } else if (!passed) {
                if (!showPassed && isSuitesFirstTest) {
                    term.white(`📙 ${suite}\n`)
                    isSuitesFirstTest = false
                }
                term.white(indent).red(`💣 Failed: ${name} ${suffix}\n`).white(indent).yellow(`${errorMessage}\n`)
            }
        } else if (type === 'testFailed') {
            Object.assign(currentTest, { passed: false, message })
        } else if (type === 'testSuiteFinished') {
            currentSuite.pop()
            isSuitesFirstTest = true
        } else if (type === 'testRunnerFinished') {
            callback(results)
        }
    }
}

const run = (engine, url, { launchSettings, processorSettings } = {}) => {
    return new Promise(async (resolve) => {
        const browser = await engine.launch(launchSettings)
        const context = await browser.newContext()
        const page = await context.newPage()
        const engineName = engine.name()

        const cb = (results) => {
            browser.close()
            resolve(results)
        }
        const processor = createMessageProcessor(cb, { ...processorSettings, browser: engineName })

        await page.exposeFunction('report', (data) => {
            if (Array.isArray(data)) {
                data.forEach(processor)
            } else {
                processor(data)
            }
        })

        page.on("pageerror", exception => term.white(exception));
        page.on('console', msg => term.white(msg.text()));

        await page.goto(url)
        // await page.screenshot({ path: 'screenshot.png' });
    })
}

const getRunner = (browser, toolkit) => {
    return async () => {
        const engine = playwright[browser]
        const id = `${toolkit}-${browser}`
        //const url = `http://127.0.0.1:1841/ext/${toolkit}/${toolkit}/test/local/?collapseAll=true&headless-test=true`;
        let url = sdkHost + `ext/${toolkit}/${toolkit}/test/local/?headless-test=true`;

        if (singleTest) {
            url += '&load=' + singleTest;
        }

        if (disableLeakCheks) {
            url += '&disableLeakChecks=true';
        }

        const start = performance.now()
        const results = await run(engine, url, {
            launchSettings: { headless: true },
            processorSettings: { showPassed: showPass, toolkit },
        })

        return { id, results, time: formatDistance(start, performance.now()) }
    }
}

var server;
if (doNotRunWebServer === false) {
    const PORT = 1842;
    server = createServer(
        {
            root: '../SDK3/'
        }
    );
    server.listen(PORT);
    term.green(`Server Listening on port ${PORT}\n`);
}

const testStartTime = performance.now()
let totalTestsRun = 0
let totalTestsFailed = 0
const allResults = await Promise.all(
    toolkits
        .map((toolkit) => browsers.map((browser) => [browser, toolkit]))
        .flat()
        .map(([browser, toolkit]) => getRunner(browser, toolkit))
        .map((runner) => runner())
)
const testEndTime = performance.now()

term.white('\n')
allResults.forEach(({ id, results, time }) => {
    const failed = results.filter((result) => !result.passed)
    const totalFailures = failed.length

    totalTestsRun += results.length


    term.bgWhite.black(`${results.length} test ran in ${time} on ${id}. `)

    if (totalFailures) {
        totalTestsFailed += totalFailures
        fs.writeFileSync(resolve(resultsDir, `${testRunId}-${id}.json`), JSON.stringify(failed, 0, 2))
        term.bgWhite.red(`${totalFailures} failed.  👎\n`)
    } else {
        term.bgWhite.green('All Passed 💪\n')
    }

})

term.bgBlue.white(`${totalTestsRun} tests ran in ${formatDistance(testStartTime, testEndTime)}. `)

if (totalTestsFailed) {
    term.bgBlue.red(`${totalTestsFailed} total failed tests. 👎`)
} else {
    term.bgBlue.green('All Passed 💪\n')
}

if (doNotRunWebServer === false) {
    server.close();
}
