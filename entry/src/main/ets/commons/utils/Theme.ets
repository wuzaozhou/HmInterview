import { ConfigurationConstant } from "@kit.AbilityKit"
import { PersistenceV2 } from "@kit.ArkUI"

export const ColorModeKey = 'hc_color-mode'

@ObservedV2
export class ThemeMode {
  @Trace mode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT
}

export class Theme {
  static initTheme() {
    const themeMode = PersistenceV2.connect(ThemeMode, () => new ThemeMode())!
    getContext().getApplicationContext().setColorMode(themeMode.mode)
  }

  static setTheme(mode: ConfigurationConstant.ColorMode) {
    const themeMode = PersistenceV2.connect(ThemeMode, () => new ThemeMode())!
    themeMode.mode = mode
    getContext().getApplicationContext().setColorMode(mode)
  }

  static getTheme() {
    const themeMode = PersistenceV2.connect(ThemeMode, () => new ThemeMode())!
    return themeMode.mode
  }

  // 跟随系统
  static notSet() {
    Theme.setTheme(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
  }

  // 暗色
  static setDark() {
    Theme.setTheme(ConfigurationConstant.ColorMode.COLOR_MODE_DARK)
  }

  // 亮色
  static setLight() {
    Theme.setTheme(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
  }
}
