import { HmNavBar } from "../../commons/components/HmNavBar"
import { Auth } from "../../commons/utils/Auth"
import { navPathStack } from "../../commons/utils/navPathStack"
import { Theme } from "../../commons/utils/Theme"
import { User } from "../../models"
import { SettingThemeDialog } from "./Theme/SettingThemeDialog"
import { ConfigurationConstant } from "@kit.AbilityKit"
import { storageStatistics } from "@kit.CoreFileKit"
import { SettingModule } from "./SettingModule"

@ComponentV2
export struct SettingPage {

  @Local module: SettingModule = new SettingModule()

  @Builder
  toolsBuilder(tool: Tool) {
    ListItem() {
      Row() {
        if (tool.icon) {
          Image(tool.icon)
            .width(16)
            .aspectRatio(1)
            .margin({
              right: 12
            })
        }
        Text(tool.name)
          .fontSize(16)
        Blank()

        if (tool.value) {
          Text(tool.value)
            .fontSize(14)
            .fontColor($r('app.color.common_gray_01'))
            .margin({ right: 10 })
        }
        Image($r('sys.media.ohos_ic_public_arrow_right'))
          .width(18)
          .aspectRatio(1)
          .fillColor($r('app.color.common_gray_01'))
      }
      .height(50)
      .width('100%')
      .backgroundColor($r('app.color.white'))
      .padding({ left: 16, right: 10 })
      .borderRadius({
        topLeft: tool.radius === 1 ? 8 : 0,
        topRight: tool.radius === 1 ? 8 : 0,
        bottomLeft: tool.radius === 2 ? 8 : 0,
        bottomRight: tool.radius === 2 ? 8 : 0
      })
      .onClick(() => {
        tool.onClick && tool.onClick()
      })
    }
  }

  @Builder
  blankBuilder() {
    ListItem() {
      Row().height(15)
    }
  }

  themeDialog: CustomDialogController = new CustomDialogController({
    builder: SettingThemeDialog(),
    customStyle: true,
    alignment: DialogAlignment.Center
  })



  aboutToAppear() {
    this.module.calcCache()
    this.module.getVersion()
  }

  build() {
    NavDestination(){
        Column(){
          HmNavBar({
            title: "设置",
            showRightIcon: false
          })
          List() {
            this.blankBuilder()
            this.toolsBuilder({
              name: '编辑资料', radius: 1, onClick: () => {
                Auth.checkAuth({
                  name: 'ProfilePage'
                })
              }
            })
            this.toolsBuilder({ name: '账号设置', radius: 2 })
            this.blankBuilder()
            this.toolsBuilder({ name: '消息推送', radius: 1 })
            this.toolsBuilder({
              name: '深色模式',
              value: Theme.getTheme() !== ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? '已关闭' : '已开启',
              radius: 1,
              onClick: () => {
                this.themeDialog.open()
              }
            })
            this.toolsBuilder({
              name: '清除应用缓存', value: this.module.cache, onClick: () => {
                this.module.clearCache()
              }
            })
            this.toolsBuilder({ name: '当前版本', value: this.module.version, radius: 2 })
            this.blankBuilder()
            ListItem() {
              Text('退出账号')
                .textAlign(TextAlign.Center)
                .height(50)
                .fontColor($r('app.color.common_main_color'))
                .opacity(0.6)
                .onClick(async () => {
                  Auth.setUser({} as User)
                  navPathStack.pop()
                })
                .width('100%')
            }
          }
          .layoutWeight(1)
          .padding({ right: 15, left: 15 })
          .backgroundColor($r('app.color.common_gray_bg'))
        }
    }
    .hideTitleBar(true)
  }
}

@Builder
export function SettingBuilder() {
  SettingPage()
}

export interface Tool {
  icon?: ResourceStr
  name: string
  value?: string
  onClick?: () => void,
  radius?: 0 | 1 | 2
}
