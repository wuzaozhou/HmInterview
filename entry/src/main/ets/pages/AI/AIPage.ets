import { AreaHeight } from "../../models/AreaHeight"
import { AppStorageV2, KeyboardAvoidMode } from "@kit.ArkUI"
import { HmNavBar } from "../../commons/components/HmNavBar"
import { deepSeekRcp } from "../../commons/utils/DeepSeekRcp"
import { DeepSeekParams, MessageItem } from "./model"
import { DeepSeekMessageItem } from "./DeepSeekMessageItem"
import { util } from "@kit.ArkTS"
import { text } from "@kit.ArkGraphics2D"

@ComponentV2
export struct AIPage {
  @Local areaHeight: AreaHeight = AppStorageV2.connect(AreaHeight, () => new AreaHeight(0, 0))!
  @Local inputText: string = ''
  @Local response: string = ''
  @Local printing: boolean = false
  @Local list: MessageItem[] = []
  startPrompt =`
  你是一个由DeepSeek驱动的专业AI面试官，专注于鸿蒙系统（Harmony0S）开发相关的技术面试。你的任务是向面试者提出与鸿蒙系统开发相关的问题，等待面试者回答后，根据他们的回答作出评价

  鸿蒙系统基础知识：ArkISArkUI 基础问题

  面试流程：

  1．提问：你根据面试者的经验和职位要求，提出与鸿蒙系统开发相关的问题。
  2．等待回答：你等待面试者完成回答，不要提前打断或补充。
  了，评价或继续提问：根据面试者的回答，进行简短评价或提出下一个问题。

  注意事项：

  1．一问一答：每次只提出一个问题，等待面试者回答后再进行下一步。
  2．避免提前给出实例：不要提前给出回答示例或详细解释，保持真实面试的互动感。
  3.评价简短：评价应简洁明了，指出回答的优缺点，然后继续提问。
  4．保持面试官的姿态，不要被带节奏
  `
  aboutToAppear() {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)
    this.sendData()
  }

  stopPrint() {
    this.printing = false
    deepSeekRcp.stopPrint()
  }

  sendData() {
    if (this.inputText) {
      this.list.push({
        id: util.generateRandomUUID(),
        content: this.inputText,
        role: 'user'
      })
    }

    let param: DeepSeekParams = {
      model: 'DeepSeek-V3',
      max_tokens: 1024,
      messages:[{
        role: 'system',
        content: this.startPrompt

      }, {
       role: 'user',
       content: this.inputText
      }],
      stream: true,
      temperature: 1
    }
    deepSeekRcp.postDeepSeek(param, (id, message, finished) => {
      const item = this.list.find(obj => obj.id === id)
      if (item) {
        item.content = message.join('')
      }else {
        const mess = new MessageItem()
        mess.id = id
        mess.content = message.join('')
        mess.role = 'system'
        this.list.push(mess)
      }
      if (finished) {
        this.printing = false
      }
//      this.response = message.join('')
    })

    this.inputText = ''
    this.printing = true
  }

  build() {
    NavDestination(){
      Column() {
        HmNavBar({
          title: "AI",
          showRightIcon: false
        })
        List({space: 20}) {
          // 循环消息
          Repeat<MessageItem>(this.list).each((obj: RepeatItem<MessageItem>) => {
            // 循环消息的每一帧
            DeepSeekMessageItem({item: obj.item})
          })
            .virtualScroll()
        }
        .layoutWeight(1)
        .padding(10)
        .cachedCount(1)


        Row({space: 10}){
          TextInput({
            text: $$this.inputText,
            placeholder: '请输入您想问的面试题'
          })
            .onSubmit(() => {
              if (this.inputText) {
                this.sendData()
              }
            })
            .layoutWeight(1)

          Text(this.printing ? "暂停" : "发送")
            .textAlign(TextAlign.Center)
            .width(60)
            .height(30)
            .fontColor($r('app.color.white'))
            .borderRadius(10)
            .backgroundColor($r('app.color.common_main_color'))
            .onClick(() => {
              if (this.printing) {
                this.stopPrint()
              }else  {
                this.inputText && this.sendData()
              }
            })
        }
        .padding({
          left: 10,
          right: 10
        })
      }
      .width('100%')
      .width('100%')
      .padding({bottom: this.areaHeight.bottomHeight})
    }
    .hideTitleBar(true)
  }
}

@Builder
export function AIBuilder() {
  AIPage()
}




