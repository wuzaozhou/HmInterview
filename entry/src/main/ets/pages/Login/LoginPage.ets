import { AreaHeight } from "../../models/AreaHeight"
import { AppStorageV2, PersistenceV2, promptAction } from "@kit.ArkUI"
import { HmNavBar } from "../../commons/components/HmNavBar"
import { http } from "../../commons/utils/Http"
import { AppUser, LoginParams, User, WebPageParam } from "../../models"
import { navPathStack } from "../../commons/utils/navPathStack"
import { Auth } from "../../commons/utils/Auth"
import { WebPage } from "../Web/WebPage"
import { tracking } from "../../commons/utils/Tracking"


@ComponentV2
export struct LoginPage {

  @Local areaHeight: AreaHeight = AppStorageV2.connect(AreaHeight, () => new AreaHeight(0, 0))!

  @Local
  mobile: string = 'hmheima'
  @Local
  code: string = 'Hmheima%123'
  @Local
  isAgree: boolean = false
  @Local
  loading: boolean = false

  async login() {
    if (this.loading) {
      return
    }
    if (!this.mobile) {
      return promptAction.showToast({ message: '请输入用户名' })
    }
    if (!this.code) {
      return promptAction.showToast({ message: '请输入密码' })
    }
    if (!this.isAgree) {
      return promptAction.showToast({ message: '请勾选已阅读并同意' })
    }

    try {
      this.loading = true
      const user = await http.request<User, LoginParams>({
        url: 'login', method: 'post', data: {
          username: this.mobile,
          password: this.code
        }
      })
      this.loading = false
//      PersistenceV2.connect(AppUser, () => new AppUser(user))
      Auth.setUser(user)
      tracking.report()
      const param = navPathStack.getParamByName('LoginPage')[0] as Record<string, string>
      if (param?.return_name) {
        navPathStack.replacePath({
          name: param.return_name, param
        })
      }else {
        navPathStack.pop()
      }

    } catch (e) {
      this.loading = false
      promptAction.showToast({ message: e.message })
    }
  }

  build() {
    NavDestination() {
      Column() {
        HmNavBar({ showRightIcon: false })
        Column() {
          Image($r('app.media.icon'))
            .width(120)
            .aspectRatio(1)
          Text('面试通')
            .fontSize(28)
            .margin({ bottom: 15 })
          Text('搞定企业面试真题，就用面试通')
            .fontSize(14)
            .fontColor($r('app.color.common_gray_01'))
        }
        .padding(16)

        Column({ space: 15 }) {
          TextInput({ placeholder: '请输入用户名', text: $$this.mobile })
            .customStyle()
          TextInput({ placeholder: '请输入密码', text: $$this.code })
            .type(InputType.Password)
            .showPasswordIcon(false)
            .customStyle()
          Row() {
            Checkbox()
              .shape(CheckBoxShape.ROUNDED_SQUARE)
              .selectedColor('#fa711d')
              .size({ width: 14, height: 14 })
              .select(this.isAgree)
              .onChange((val) => {
                this.isAgree = val
              })
            Text('已阅读并同意')
              .fontSize(14)
              .fontColor($r('app.color.common_gray_01'))
              .padding({ right: 4 })
            Text('用户协议')
              .fontSize(14)
              .padding({ right: 4 })
              .onClick(() => {
                navPathStack.pushPath({
                  name: 'WebPage',
                  param: { title: '用户协议', src: 'http://110.41.143.89/user' } as WebPageParam
                })
              })
            Text('和')
              .fontSize(14)
              .fontColor($r('app.color.common_gray_01'))
              .padding({ right: 4 })
            Text('隐私政策')
              .fontSize(14)
              .onClick(() => {
                navPathStack.pushPath({
                  name: 'WebPage',
                  param: { title: '隐私政策', src: 'http://110.41.143.89/privacy' } as WebPageParam
                })
              })
          }
          .width('100%')

          Button({ type: ButtonType.Normal }) {
            Row() {
              if (this.loading) {
                LoadingProgress()
                  .color($r('app.color.white'))
                  .width(24)
                  .height(24)
                  .margin({ right: 10 })
              }
              Text('立即登录')
                .fontColor($r('app.color.white'))
            }
          }
          .width('100%')
          .backgroundColor('none')
          .borderRadius(4)
          .height(44)
          .linearGradient({
            direction: GradientDirection.Right,
            colors: [['#fc9c1c', 0], ['#fa711d', 1]]
          })
          .stateEffect(false)
          .onClick(() => {
            this.login()
          })
        }
        .padding({ left: 36, right: 36, top: 30 })


        Column() {
          Text('其他登录方式')
            .fontSize(14)
            .fontColor($r('app.color.common_gray_01'))
        }
        .padding({ top: 70, bottom: 100 })

      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
  }
}

@Builder
export function LoginBuilder() {
  LoginPage()
}


@Extend(TextInput)
function customStyle() {
  .placeholderColor('#C3C3C5')
  .caretColor('#fa711d')
  .height(44)
  .borderRadius(0)
  .backgroundColor($r('app.color.white'))
  .border({ width: { bottom: 0.5 }, color: $r('app.color.common_gray_border') })
}
