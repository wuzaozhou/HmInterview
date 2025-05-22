import { window } from "@kit.ArkUI"

class FullScreen {
  async enable() {
    let win = await window.getLastWindow(getContext())
    await win.setWindowLayoutFullScreen(true)
  }

  async disable() {
    let win = await window.getLastWindow(getContext())
    await win.setWindowLayoutFullScreen(false)
  }

}

export const  fullScreen = new FullScreen()
