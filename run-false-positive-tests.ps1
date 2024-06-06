$testRunnerFileName = 'run-tests.js'
$sdkUrlKey = '-sdk-url'
$sdkUrlValue = 'http://127.0.0.1:1841/'
$singleTestKey = '-single-test'
$nodeJsExecutable = 'node.exe'

$disableLeakChecksForTest = @(
  'Ext.calendar.panel.Panel'
  'Ext.grid.Grid'
)

$falsePositiveTests = @(
  'Ext.calendar.panel.Panel'
  'Ext.pivot.Grid.classic'
  'Ext.draw.Surface'
  'Ext.grid.filters.Filters'
  'Ext.froala.Editor.classic'
  'Ext.draw.Matrix'
  'Ext.froala.EditorField.classic'
  'Ext.froala.Editor'
  'Ext.froala.EditorField'
  'grid-general-buffered-preserve-scroll'
  'Ext.data.Store'
  'Ext.data.schema.ManyToOne'
  'Ext.data.TreeStore'
  'Ext.layout.container.Table'
  'grid-cell-edit'
  'Ext.grid.Grid'
  'Ext.grid.filters.Plugin'
  'Ext.grid.plugin.Editable'
)

if (Test-Path $testRunnerFileName) {
  foreach ($singleTestValue in $falsePositiveTests) {
    $args = @($testRunnerFileName, $sdkUrlKey, $sdkUrlValue, $singleTestKey, $singleTestValue);
    if ($disableLeakChecksForTest -contains $singleTestValue) {
      $args += '-disable-leak-checks';
      $args += 'true'
    }
    $paramStr = $args -join ' '
    Write-Output "Run: $nodeJsExecutable $paramStr"
    & $nodeJsExecutable $args;
  }
}
else {
  Write-Output "File $testRunnerFileName is not found."
}