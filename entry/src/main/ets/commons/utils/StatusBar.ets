import { window } from '@kit.ArkUI'

class StatusBar {
  setDarkBar () {
    this.setBar({
      statusBarContentColor: '#FFFFFF'
    })
  }
  setLightBar() {
    this.setBar({
      statusBarContentColor: '#000000'
    })
  }
  async setBar(config: window.SystemBarProperties) {
    let win = await window.getLastWindow(getContext())
    await win.setWindowSystemBarProperties(config)
  }
}
