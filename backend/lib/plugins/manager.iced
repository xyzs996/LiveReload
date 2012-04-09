fs   = require 'fs'
Path = require 'path'

LRPlugin = require './plugin'


class LRPluginManager

  constructor: (@folders) ->
    unless @folders.length?
      throw new Error("No plugin folders specified")

  rescan: (callback) ->
    pluginFolders = []
    for folder in @folders
      for entry in fs.readdirSync(folder) when entry.endsWith('.lrplugin')
        pluginFolders.push Path.join(folder, entry)

    @plugins = []
    await
      for pluginFolder in pluginFolders
        plugin = new LRPlugin(pluginFolder)
        plugin.initialize defer(err)
        return callback(err) if err
        @plugins.push(plugin)

    @compilers = {}
    for plugin in @plugins
      Object.merge @compilers, plugin.compilers

    callback(null)


module.exports = LRPluginManager
