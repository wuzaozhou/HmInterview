import { PersistenceV2 } from "@kit.ArkUI";
import { AppUser, User } from "../../models";
import { navPathStack } from "./navPathStack";

export class Auth {
  static setUser (user: User) {
    const appUser = PersistenceV2.connect(AppUser, () => new AppUser())!
    appUser.user.id = user.id
    appUser.user.username = user.username
    appUser.user.avatar = user.avatar
    appUser.user.token = user.token
    appUser.user.nickName = user.nickName
    appUser.user.totalTime = user.totalTime
    appUser.user.clockinNumbers = user.clockinNumbers
    appUser.user.username = user.username
  }

  static getUser() {
    const appUser = PersistenceV2.connect(AppUser, () => new AppUser())!
    return appUser.user
  }

  static checkAuth(option: Function | NavPathInfo) {
    const user = Auth.getUser()
    if (typeof option === 'function') {
      if (user.token) {
        option()
      }else {
        navPathStack.pushPath({
          name: 'LoginPage'
        }, {
          launchMode: LaunchMode.MOVE_TO_TOP_SINGLETON
        })
      }
    }else {
      if (user.token) {
        navPathStack.pushPath(option)
      }else {
        const param = option.param as Record<string, string> ||{}
        param.return_name = option.name
        navPathStack.pushPath({
          name: 'LoginPage',
          param
        }, {
          launchMode: LaunchMode.MOVE_TO_TOP_SINGLETON
        })
      }
    }
  }
}
