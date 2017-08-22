"use strict";

var electron = require('electron');
var ipcMain  = electron.ipcMain;

exports.registerAsyncHandlerImpl = function registerAsyncHandlerImpl (params) {
  ipcMain.on(params.channel, function handleAsyncImpl (event, arg) {
    params.handle({
      message: arg,
      send: function sendImpl (sendParams) {
        event.sender.send(sendParams.channel, sendParams.message);
      }
    });
  });
};


exports.registerSyncHandlerImpl = function registerSyncHandlerImpl (params) {
  ipcMain.on(params.channel, function handleSyncImpl (event, arg) {
    var result = params.handle(arg);
    event.returnValue = result;
  });
};
