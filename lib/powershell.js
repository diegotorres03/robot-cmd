const fs = require('fs');

var ps_click = fs.readFileSync('./lib/Clicker.ps1', 'utf8');
var ps_screenshot = fs.readFileSync('./lib/Take-ScreenShot.ps1', 'utf8');

var scripts = `
${ps_click}
${ps_screenshot}\n
`

exports.shell = 'powershell'
exports.script = scripts
exports.moveTo = function (x,y) {
  return `[Clicker]::MoveToPoint(${x},${y})\n`
};
exports.leftClick = function () {
  return `[Clicker]::LeftClick()\n`
};
exports.rightClick = function () {
  return `[Clicker]::RightClick()\n`
};
exports.screenShot = function (savePath) {
  return `Take-ScreenShot -file "${savePath}" -screen\n`
};