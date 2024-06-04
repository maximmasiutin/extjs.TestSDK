#!/bin/sh

testRunerFileName='./run-tests.js';
runParams='-sdk-url http://127.0.0.1:1841/';
nodeJs='node';
disableLeakChecks='';

# shellcheck disable=SC2039
disableLeakChecksForTest=(
  'Ext.calendar.panel.Panel'
  'Ext.grid.Grid'
  'Ext.grid.plugin.Editable'
);

# shellcheck disable=SC2039
falsePositiveTests=(
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
);

# shellcheck disable=SC2039
if [[ -f "$testRunerFileName" ]]
then
  for value in "${falsePositiveTests[@]}"
  do
    # shellcheck disable=SC2199
    if [[ ${disableLeakChecksForTest[@]} =~ $value ]]
    then
      disableLeakChecks=' -disable-leak-checks true';
    else
      disableLeakChecks='';
    fi

    $nodeJs $testRunerFileName $runParams $disableLeakChecks -single-test $value
  done
else
    echo "File '$testRunerFileName' is not found."
fi
