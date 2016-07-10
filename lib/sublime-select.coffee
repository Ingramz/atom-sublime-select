packageName = "Sublime-Style-Column-Selection"

os = require 'os'
SublimeSelectEditorHandler = require './editor-handler.coffee'

defaultCfg = switch os.platform()
  when 'win32'
    selectKey:     'altKey'
    selectKeyName: 'Alt'
    mouseNum:      1
    mouseName:     "Left"
  when 'darwin'
    selectKey:     'altKey'
    selectKeyName: 'Alt'
    mouseNum:      1
    mouseName:     "Left"
  when 'linux'
    selectKey:     'shiftKey'
    selectKeyName: 'Shift'
    mouseNum:      1
    mouseName:     "Left"
  else
    selectKey:     'shiftKey'
    selectKeyName: 'Shift'
    mouseNum:      1
    mouseName:     "Left"

mouseNumMap =
  Left:   1,
  Middle: 2,
  Right:  3

selectKeyMap =
  Shift: 'shiftKey',
  Alt:   'altKey',
  Ctrl:  'ctrlKey',
  None:  null

inputCfg = defaultCfg

module.exports =

  config:
    mouseButtonTrigger:
      title: "Mouse Button"
      description: "The mouse button that will trigger column selection.
        If empty, the default will be used #{defaultCfg.mouseName} mouse button."
      type: 'string'
      enum: (key for key, value of mouseNumMap)
      default: defaultCfg.mouseName

    selectKeyTrigger:
      title: "Select Key"
      description: "The key that will trigger column selection.
        If empty, the default will be used #{defaultCfg.selectKeyName} key."
      type: 'string'
      enum: (key for key, value of selectKeyMap)
      default: defaultCfg.selectKeyName

  activate: (state) ->
    @observers = []

    @observers.push atom.config.observe "#{packageName}.mouseButtonTrigger", (newValue) =>
      inputCfg.mouseName = newValue
      inputCfg.mouseNum = mouseNumMap[newValue]

    @observers.push atom.config.observe "#{packageName}.selectKeyTrigger", (newValue) =>
      inputCfg.selectKeyName = newValue
      inputCfg.selectKey = selectKeyMap[newValue]

    @observers.push atom.workspace.observeTextEditors (editor) ->
      editor_handler = new SublimeSelectEditorHandler(editor, inputCfg)
      editor_handler.subscribe()

      editor.onDidDestroy ->
        editor_handler.unsubscribe()

  deactivate: ->
    observer.dispose() for observer in @observers
    @observers = null
