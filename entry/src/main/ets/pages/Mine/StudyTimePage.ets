import { HmNavBar } from "../../commons/components/HmNavBar"
import { AreaHeight } from "../../models/AreaHeight"
import { AppStorageV2 } from "@kit.ArkUI"
import { HmLoadingDialog } from "../../commons/components/HmLoadingDialog"
import { http } from "../../commons/utils/Http"
import { StudyTimeData, StudyTimeItem } from "../../models"
import { calcPercentage, formatTime } from "../../commons/utils"

@ComponentV2
export struct StudyTimePage {

  @Local areaHeight: AreaHeight = AppStorageV2.connect(AreaHeight, () => new AreaHeight(0, 0))!

  @Local data: StudyTimeData = {
    totalTime: 0,
    studyData: []
  }
  dialog: CustomDialogController = new CustomDialogController({
    builder: HmLoadingDialog({ message: '加载中...' }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  async aboutToAppear() {
    this.dialog.open()
    const res = await http.request<StudyTimeData>({ url: 'studyInfo' })
    this.data = res
    this.dialog.close()
  }

  @Builder

  ProgressBuilder(title: string, done: number, total: number, color: string = '#87E0CD') {
    GridCol() {
      Column() {
        Row() {
          Text(title)
            .fontColor($r('app.color.common_gray_01'))
            .fontSize(14)
          Text(calcPercentage(done, total))
            .fontColor($r('app.color.common_gray_01'))
            .fontSize(14)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ bottom: 5 })

        Progress({ value: done, total: total })
          .color(color)
          .width('100%')
      }
    }
  }

  @Builder
  DotBuilder(color: string, isDark: boolean) {
    Row() {
      Text()
        .width(7)
        .aspectRatio(1)
        .borderRadius(4)
        .backgroundColor(isDark ? color : $r('app.color.common_gray_01'))
        .margin({ right: 4 })
      Text(isDark ? '已学占比' : '未学占比')
        .fontSize(12)
        .fontColor(isDark ? $r('app.color.common_gray_03') : $r('app.color.common_gray_01'))
    }
  }



  build() {
    NavDestination(){
      Column() {
        HmNavBar({ title: '学习数据', showRightIcon: false })
        Column() {
          Scroll() {
            Column() {
              // time
              Column() {
                Row() {
                  Text('累计学习时长')
                    .margin({ right: 5 })
                    .fontColor($r('app.color.common_gray_03'))
                  Image($r('sys.media.ohos_ic_public_clock'))
                    .width(16)
                    .aspectRatio(1)
                    .fillColor($r('app.color.common_green'))
                }
                .width('100%')
                .margin({ bottom: 10 })

                Row() {
                  Text(formatTime(this.data.totalTime).replace(/分钟|小时|天/,''))
                    .fontSize(40)
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.common_green'))
                  Text(formatTime(this.data.totalTime).replace(/\d|\./g,''))
                    .margin({ bottom: 8, left: 8 })
                    .fontColor($r('app.color.common_green'))
                }
                .width('100%')
                .alignItems(VerticalAlign.Bottom)
              }

              // knowledge
              if (this.data.studyData[0]) {
                // knowledge
                Text('知识点学习进度')
                  .margin({ bottom: 10, top: 30 })
                  .width('100%')
                GridRow({ columns: 2, gutter: 20 }) {
                  ForEach(this.data.studyData[0].list, (item: StudyTimeItem) => {
                    this.ProgressBuilder(item.name, item.done, item.total)
                  })
                  GridCol({ span: 2 }) {
                    Row({ space: 16 }) {
                      this.DotBuilder('#87E0CD', true)
                      this.DotBuilder('#87E0CD', false)
                    }
                    .margin({ top: 10 })
                  }
                }
                .backgroundColor($r('app.color.white'))
                .padding(16)
                .borderRadius(8)
                .shadow({ color: $r('app.color.common_gray_border'), radius: 16 })
              }

              if (this.data.studyData[1]) {
                // project
                Text('项目学习进度')
                  .margin({ bottom: 10, top: 30 })
                  .width('100%')
                GridRow({ columns: 1, gutter: 20 }) {
                  ForEach(this.data.studyData[1].list, (item: StudyTimeItem) => {
                    this.ProgressBuilder(item.name, item.done, item.total, '#C7B5ED')
                  })
                  GridCol() {
                    Row({ space: 16 }) {
                      this.DotBuilder('#C7B5ED', true)
                      this.DotBuilder('#C7B5ED', false)
                    }
                    .margin({ top: 10 })
                  }
                }
                .backgroundColor($r('app.color.white'))
                .padding(16)
                .borderRadius(8)
                .shadow({ color: $r('app.color.common_gray_border'), radius: 16 })
              }
            }
            .padding(16)
            .margin({ bottom: this.areaHeight.bottomHeight })
          }
          .scrollBar(BarState.Off)
        }
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .backgroundImage($r('app.media.study_time_bg'))
      .backgroundImageSize({ width: '100%' })
      .backgroundColor($r('app.color.common_gray_bg'))
    }
    .hideTitleBar(true)
  }
}

@Builder
export function StudyTimeBuilder() {
  StudyTimePage()
}
