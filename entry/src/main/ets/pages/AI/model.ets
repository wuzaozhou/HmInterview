export interface StreamOptions {
  include_usage: boolean
}
export interface DeepSeekParams {
  model: string
  max_tokens: number; messages: Message[]
  stream: boolean
  stream_options?: StreamOptions;
  temperature: number
}

@ObservedV2
export class MessageItem implements Message {
  role: 'system' | 'user' | 'assistant' = 'system'
  id: string = ''
  @Trace content: string = ''
}


export interface Message {
  role: 'system' | 'user' | 'assistant'
  content: string
}
