import { AppStorageV2, window } from "@kit.ArkUI"
import { AreaHeight } from "../../../models/AreaHeight"
import { SavedContext } from "../../../models/SavedContext"

class FullScreen {

  async enable() {
//    let win = await window.getLastWindow(getContext())
    let context = AppStorageV2.connect(SavedContext)!.context
    let win = await window.getLastWindow(context)
    await win.setWindowLayoutFullScreen(true)

    let topArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
    let bottomArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
    let topHeight = topArea.topRect.height // 默认拿到的px
    let bottomHeight = bottomArea.bottomRect.height // 默认拿到的px
    let areaHeight = AppStorageV2.connect(AreaHeight, () => new AreaHeight(0, 0))!
    areaHeight.topHeight = px2vp(topHeight)
    areaHeight.bottomHeight = px2vp(bottomHeight)

  }

  async disable() {
//    let win = await window.getLastWindow(getContext())
    let context = AppStorageV2.connect(SavedContext)!.context
    let win = await window.getLastWindow(context)
    await win.setWindowLayoutFullScreen(false)

    let areaHeight = AppStorageV2.connect(AreaHeight, () => new AreaHeight(0, 0))!
    areaHeight.topHeight = 0
    areaHeight.bottomHeight = 0
  }

}

export const  fullScreen = new FullScreen()
