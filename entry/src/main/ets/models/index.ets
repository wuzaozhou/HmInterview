import { Type } from "@kit.ArkUI"

export interface TabItem {
  icon: Resource
  activeIcon: Resource
  name: string
}

export interface QuestionType {
  id: number
  name: string
  displayNewestFlag: 0 | 1
}

export interface QuestionItem {
  id: string;
  /* 题干 */
  stem: string;
  /* 难度 */
  difficulty: number;
  /* 点赞数 */
  likeCount: number;
  /* 浏览数 */
  views: number;
  /* 是否已看 */
  readFlag: 0 | 1;
}


export interface PageData<T> {
  total: number
  pageTotal: number
  rows: T[]
}

export enum SortType {
  Default = 0,
  DifficultyLow = 10,
  DifficultyHigh = 11,
  ViewLow = 20,
  ViewHigh = 21,
  Commend = 30
}

export interface QuestionListParams {
  type: number
  questionBankType: 9 | 10
  sort?: SortType
  page?: number
  pageSize?: number
  keyword?: string
}

@ObservedV2
export class User {
  @Trace id: string = ""
  @Trace username: string = ""
  @Trace avatar: string = ""
  @Trace token: string = ""
  @Trace nickName?: string = ""
  // 学习时长
  @Trace totalTime?: number = 0
  // 打卡次数
  @Trace clockinNumbers?: number = 0
}

export interface  LoginParams {
  username: string
  password: string
}
@ObservedV2
export class AppUser {
  @Type(User) // 对于复杂对象需要@Type 修饰，确保序列化成功
  @Trace user: User = new User()

}


export interface WebPageParam {
  title: string,
  src: string
}

export interface QuestionDetail extends QuestionItem {
  /* 答案 */
  answer: string;
  /* 是否收藏 */
  collectFlag: 0 | 1;
  /* 是否点赞 */
  likeFlag: 0 | 1;
  /* 所属模块 */
  stage: string[];
}

export interface QuestionPageParams {
  item: QuestionItem;
  list: QuestionItem[];
}

export interface QuestionOptParams {
  id: string;
  /* 0 试题  2 面经 */
  type: 0 | 1;
  /* 1 点赞  2 收藏 */
  optType: 1 | 2;
}

export interface TimeItem {
  questionId: string;
  startTime: number;
  endTime: number;
}

export interface ClockInItem {
  id: string,
  createdAt: string
}

export interface ClockInfo {
  flag: boolean
  clockinNumbers: number
  totalClockinNumber: number
  clockins: ClockInItem[]
}

export interface ClockInfoParams {
  year: string,
  month: string
}

// 学习时间

export interface StudyTimeItem {
  id: string
  name: string
  total: number
  done: number
  undone: number
}

export interface StudyTimeCate {
  type: string,
  list: StudyTimeItem[]
}

export interface StudyTimeData {
  totalTime: number,
  studyData: StudyTimeCate[]
}


export interface WordItem {
  zh: string
  en: string
  code: string
}


