import { promptAction, router } from '@kit.ArkUI'
import { Auth } from './Auth'
import { http } from './Http'
import { navPathStack } from './navPathStack'


interface ClockRes {
  clockinNumbers: number
}

export const requestClockIn = async () => {
  const user = Auth.getUser()
  if (user.token) {
    if (user.clockinNumbers === 0) {
      const res = await http.request<ClockRes>({ url: 'clockin', method: 'post' })
      user.clockinNumbers = res.clockinNumbers
      Auth.setUser(user)
      promptAction.showToast({ message: '打卡成功' })
    }
    navPathStack.pushPath({
      name: "ClockInPage"
    })
  } else {
    navPathStack.pushPath({
      name: "LoginPage"
    })
  }
}
