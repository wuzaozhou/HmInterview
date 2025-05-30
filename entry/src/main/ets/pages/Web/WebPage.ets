import { HmNavBar } from "../../commons/components/HmNavBar"
import { navPathStack } from "../../commons/utils/navPathStack"
import { WebPageParam } from "../../models"
import { webview } from "@kit.ArkWeb"

@ComponentV2
export struct WebPage {

  @Local title: string = ''
  @Local src: string = ''
  controller = new webview.WebviewController()
  aboutToAppear(): void {
    const param = navPathStack.getParamByName('WebPage').pop() as WebPageParam
    this.title = param.title
    this.src = param.src
  }

  build() {
    NavDestination() {
      HmNavBar({title: this.title, showRightIcon: false})

      Web({
        src: this.src,
        controller: this.controller
      })
        .layoutWeight(1)
        .width('100%')
    }
    .hideTitleBar(true)
  }
}

@Builder
export function WebBuilder() {
  WebPage()
}
