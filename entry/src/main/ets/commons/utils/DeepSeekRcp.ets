import { rcp } from "@kit.RemoteCommunicationKit";
import { util } from "@kit.ArkTS";
import { logger } from ".";


const url = "https://api.modelarts-maas.com/v1/chat/completions"
const APIkey = "4tSZ2GLwPaff2duUugeRJtorGu2hPF4kpGV5c6DIqzZxgtBGAa3P38CDlkRCZYaLla2D_-4ZjCCowvraHvCQ2g"


class DeepSeekRcpRequest implements rcp.Interceptor {
  intercept(context: rcp.RequestContext, next: rcp.RequestHandler): Promise<rcp.Response> {
    context.request.headers!.authorization = `Bearer ${APIkey}`;
    return next.handle(context)
  }

}

export class DeepSeekRcp {

  session: rcp.Session | null = null

  private cacheMessage: Map<string, string[]> = new Map()
  private textCallBack?: (id: string, message: string[], finished: boolean) => void
  private currentReq: rcp.Request | null = null

  initSession() {
    this.session = rcp.createSession({
      interceptors: [
        new DeepSeekRcpRequest()
      ],
      requestConfiguration: {
        tracing: {
          httpEventsHandler: {
            onDataReceive: (bf) => {
              const uni8 = new Uint8Array(bf)
              const decoder = new util.TextDecoder()
              const str = decoder.decodeToString(uni8)

              const list = str.split('\n')
              for (let item of list) {
                const  dealStr = item.substring(5)
                if (dealStr) {
                  const message = JSON.parse(dealStr) as ChatCompletionChunk

                  if (!this.cacheMessage.has(message.id)) {
                    this.cacheMessage.set(message.id, [])
                  }
                  const list = this.cacheMessage.get(message.id)
                  message.choices.map(obj => {
                    list?.push(obj.delta.content)
                  })
                  let isFinished = false
                  if (message.choices[0].finish_reason === 'stop') {
                    isFinished = true
                  }
                  this.cacheMessage.set(message.id, list)

                  this.textCallBack?.(message.id, list, isFinished)
                  if (isFinished) {
                    this.cacheMessage.delete(message.id)
                  }
                }
              }
            }
          }
        }
      }
    })
  }




  postDeepSeek(data: object, callBack?: (id: string, message: string[], finished: boolean) => void) {
    if (!this.session) {
      this.initSession()
    }
    this.textCallBack = callBack
//    this.session?.post(url, data)


    this.currentReq = new rcp.Request(url, 'POST', {}, data)
    this.session?.fetch(this.currentReq)
  }

  stopPrint() {
    this.session?.cancel(this.currentReq)
  }
}

export const deepSeekRcp = new DeepSeekRcp()

export interface ChatCompletionChunk {
  id: string;
  object: string;
  created: number;
  model: string;
  choices: ChoiceItem[];
  usage: UsageItem;
}
export interface ChoiceItem {
  index: number;
  delta: deltaltem;
  Logprobs: null;
  finish_reason: string | null
}
export interface deltaltem {
  role: string;
  content: string;
}
export interface UsageItem {
  prompt_tokens: number;
  total_tokens: number;
  completion_tokens: number;
}
