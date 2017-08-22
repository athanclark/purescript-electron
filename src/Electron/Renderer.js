"use strict";

var electron = require('electron');
var ipcRenderer = electron.ipcRenderer;

exports.registerAsyncHandlerImpl = function registerAsyncHandlerImpl (params) {
  ipcRenderer.on(params.channel, function handleAsyncImpl (event, arg) {
    params.handle({message: arg});
  });
};

exports.sendImpl = function sendImpl (params) {
  ipcRenderer.send(params.channel, params.message);
};

exports.sendSyncImpl = function sendSyncImpl (params) {
  return ipcRenderer.sendSync(params.channel, params.message);
};
