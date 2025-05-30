import { Auth } from "./Auth"
import { promptAction } from "@kit.ArkUI"
import { LoginPage } from "../../pages/Login/LoginPage"

export const navPathStack: NavPathStack = new NavPathStack()

let AuthNames: string[] = ['QuestionPage']

navPathStack.setInterception( {
  // 页面跳转之前的拦截
  willShow(from, to: NavBar | NavDestinationContext) {
    if (typeof to === 'string') {
      // 要去的地方 是navigation首页，navBar，无需处理
      return
    }

    const targetPage = to as NavDestinationContext
    const pageName = targetPage.pathInfo.name

    if (AuthNames.includes(pageName)) {
      let user = Auth.getUser()
      if (!user.token) {
        promptAction.showToast({message: '当前用户未登录，请先登录'})
        to.pathStack.pop()
        const param = to.pathInfo.param as Record<string, string> ||{}
        param.return_name = to.pathInfo.name
        navPathStack.pushPath({
          name: 'LoginPage',
          param
        }, {
          launchMode: LaunchMode.MOVE_TO_TOP_SINGLETON
        })
        return false
      }
    }
    return true
  }
})
