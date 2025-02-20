import os
#from langchain.llms import Bedrock
from langchain_aws import ChatBedrock
from langchain.memory import ConversationBufferMemory
from langchain.chains import ConversationChain

from langchain_core.messages import HumanMessage, SystemMessage

def bedrock_chatbot():
    bedrock_llm = ChatBedrock(
        credentials_profile_name='default',
        model_id='anthropic.claude-3-5-sonnet-20240620-v1:0',
        model_kwargs = {
            # "prompt": "\n\nHuman:<prompt>\n\nAssistant:",
            "temperature": 1
            # "max_tokens_to_sample": 512
        }
    )

    return bedrock_llm


def buff_memory():
    buff_memory = bedrock_chatbot()
    memory = ConversationBufferMemory(llm=buff_memory)
    return memory

def cnvs_chain(messages):
    chain_data = bedrock_chatbot()
    cnvs_chain = ConversationChain(llm=chain_data, verbose=True)

    chat_reply = cnvs_chain.predict(input=messages)
    print(chat_reply)
    messages = "프리미어리그에서 통산 몇 골 넣었어?"
    chat_reply = cnvs_chain.predict(input=messages)
    print(chat_reply)
    

memory = buff_memory()

messages = "엘런 시어러는 현재 살아 있어?"
response = cnvs_chain(messages)

# messages = [("프리미어리그 역대 득점 순위 알려줘")]

# response = bedrock_chatbot(messages)
# print(response)