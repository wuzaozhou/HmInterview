import { Theme } from "../../../commons/utils/Theme"
import { ConfigurationConstant } from "@kit.AbilityKit"

@CustomDialog
export struct SettingThemeDialog {
  controller : CustomDialogController

  build() {
    Column() {
      Row() {
        Column({ space: 4 }) {
          Text('跟随系统')
          Text('开启后，将跟随系统打开或关闭深色模式')
            .fontSize(12)
            .fontColor($r('app.color.common_gray_01'))
        }
        .alignItems(HorizontalAlign.Start)
        Toggle({
          type: ToggleType.Switch,
          isOn: Theme.getTheme() === ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET
        })
          .onChange((val) => {
            if (val) {
              Theme.notSet()
            } else {
              Theme.setLight()
            }
          })
      }
      .width('100%')
      .height(70)

      if (Theme.getTheme() != ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) {
        Row() {
          Text('普通模式')
            .fontSize(15)
          Blank()
          if (Theme.getTheme() === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ) {
            Image($r('app.media.ic_public_ok'))
              .width(16)
              .aspectRatio(1)
              .fillColor($r('app.color.common_green'))
          }
        }
        .width('100%')
        .height(50)
        .border({ width: { bottom: 0.5 , top: 0.5}, color: $r('app.color.common_gray_border') })
        .onClick(() => {
          Theme.setLight()
          this.controller.close()
        })

        Row() {
          Text('深色模式')
            .fontSize(15)
          Blank()
          if (Theme.getTheme() === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ) {
            Image($r('app.media.ic_public_ok'))
              .width(16)
              .aspectRatio(1)
              .fillColor($r('app.color.common_green'))
          }
        }
        .width('100%')
        .height(50)
        .onClick(() => {
          Theme.setDark()
          this.controller.close()
        })
      }
    }
    .padding({
      top: 15,
      bottom: 15,
      left: 30,
      right: 30
    })
    .margin({left: 20, right: 20})
    .backgroundColor($r('app.color.white'))
    .borderRadius(20)
  }
}
