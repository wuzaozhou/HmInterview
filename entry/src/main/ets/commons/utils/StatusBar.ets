import { window } from '@kit.ArkUI'

export  class StatusBar {
  static setDarkBar () {
    StatusBar.setBar({
      statusBarContentColor: '#FFFFFF'
    })
  }
  static setLightBar() {
    StatusBar.setBar({
      statusBarContentColor: '#000000'
    })
  }
  static async setBar(config: window.SystemBarProperties) {
    let win = await window.getLastWindow(getContext())
    win.setWindowSystemBarProperties(config)
  }

  static async setHidBar() {
    let win = await window.getLastWindow(getContext())
    win.setSpecificSystemBarEnabled("status", false)
    win.setSpecificSystemBarEnabled("navigationIndicator", false)
  }
}
