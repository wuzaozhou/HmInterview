
import { fullScreen, StatusBar } from '../commons/utils';
import { AreaHeight } from '../models/AreaHeight';
import { AppStorageV2, window } from '@kit.ArkUI';
import { TabItem } from '../models';
import { HomePage } from './Home/HomePage';
import { ProjectPage } from './Project/ProjectPage';
import { InterViewPage } from './InterView/InterViewPage';
import { MinePage } from './Mine/MinePage';
import { navPathStack } from '../commons/utils/navPathStack';
import { Theme } from '../commons/utils/Theme';

Theme.initTheme()

@Entry
@ComponentV2
struct Index {
  @Local areaHeight: AreaHeight = AppStorageV2.connect(AreaHeight, () => new AreaHeight(0, 0))!
  @Local activeIndex: number = 0
  @Local tabList: TabItem[] = [
    {
      icon: $r('app.media.tabbar_home'),
      activeIcon: $r('app.media.tabbar_home_fill'),
      name: '首页'
    },
    {
      icon: $r('app.media.tabbar_project'),
      activeIcon: $r('app.media.tabbar_project_fill'),
      name: '项目'
    },
    {
      icon: $r('app.media.tabbar_interview'),
      activeIcon: $r('app.media.tabbar_interview_fill'),
      name: '面经'
    },
    {
      icon: $r('app.media.tabbar_mine'),
      activeIcon: $r('app.media.tabbar_mine_fill'),
      name: '我的'
    }
  ]

  @Builder
  TabBarBuilder(item: TabItem, index: number) {
    Column({space: 5}) {
      Image(this.activeIndex === index ? item.activeIcon : item.icon)
        .width(24)
        .aspectRatio(1)
      Text(item.name)
        .fontSize(12)
        .fontColor(this.activeIndex === index ? $r('app.color.black') : $r('app.color.common_gray_01'))
    }
  }

  build() {
    Navigation(navPathStack) {
      Column() {
        Tabs({index: $$this.activeIndex}) {
          ForEach(this.tabList, (item: TabItem, index: number) => {
            TabContent() {
              if (index === 0) {
                HomePage()
              }else if (index === 1){
                ProjectPage()
              }else if (index === 2) {
                InterViewPage()
              }else {
                MinePage()
              }
            }
            .tabBar(this.TabBarBuilder(item, index))
          })
        }
        .divider({strokeWidth: 0.5, color:$r('app.color.common_gray_border')})
        .barPosition(BarPosition.End)
        .scrollable(false)// 关闭横向的滑动
        .animationDuration(0)// 关闭切换动画
        .margin({
          bottom: this.areaHeight.bottomHeight
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.white'))
    }
    .hideTitleBar(true)
  }
}
