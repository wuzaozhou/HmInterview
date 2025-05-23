
import { fullScreen, StatusBar } from '../commons/utils';
import { AreaHeight } from '../models/AreaHeight';
import { AppStorageV2, window } from '@kit.ArkUI';
import { TabItem } from '../models';

@Entry
@ComponentV2
struct Index {
  @Local areaHeight: AreaHeight = AppStorageV2.connect(AreaHeight, () => new AreaHeight(0, 0))!

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

  build() {
    Column() {
      Tabs() {
        ForEach(this.tabList, (item: TabItem) => {
          TabContent() {
            Text(item.name)
          }
          .tabBar(item.name)
        })
      }
      .divider({strokeWidth: 0.5, color:$r('app.color.common_gray_border')})
      .barPosition(BarPosition.End)
      .scrollable(false)// 关闭横向的滑动
      .animationDuration(0)// 关闭切换动画
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.white'))
  }
}
