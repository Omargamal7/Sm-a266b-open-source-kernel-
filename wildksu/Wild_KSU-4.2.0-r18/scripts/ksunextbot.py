import os
import sys
import requests

# Environment Variables
BOT_TOKEN = os.environ.get("BOT_TOKEN")
CHAT_ID = os.environ.get("CHAT_ID")
MESSAGE_THREAD_ID = os.environ.get("MESSAGE_THREAD_ID")
COMMIT_URL = os.environ.get("COMMIT_URL")
COMMIT_MESSAGE = os.environ.get("COMMIT_MESSAGE")
RUN_URL = os.environ.get("RUN_URL")
TITLE = os.environ.get("TITLE")
VERSION = os.environ.get("VERSION")

MSG_TEMPLATE = """
**{title}**
#ci_{version}
```
{commit_message}
```
[Commit]({commit_url})
[Workflow run]({run_url})
""".strip()


def get_caption():
    msg = MSG_TEMPLATE.format(
        title=TITLE,
        version=VERSION,
        commit_message=COMMIT_MESSAGE,
        commit_url=COMMIT_URL,
        run_url=RUN_URL,
    )
    if len(msg) > 1024:
        return COMMIT_URL
    return msg


def check_environ():
    global CHAT_ID, MESSAGE_THREAD_ID
    if BOT_TOKEN is None:
        print("[-] Invalid BOT_TOKEN")
        exit(1)
    if CHAT_ID is None:
        print("[-] Invalid CHAT_ID")
        exit(1)
    
    if MESSAGE_THREAD_ID is None or MESSAGE_THREAD_ID == "":
        MESSAGE_THREAD_ID = None
        print("[*] MESSAGE_THREAD_ID not set, using default")
    
    if COMMIT_URL is None:
        print("[-] Invalid COMMIT_URL")
        exit(1)
    if COMMIT_MESSAGE is None:
        print("[-] Invalid COMMIT_MESSAGE")
        exit(1)
    if RUN_URL is None:
        print("[-] Invalid RUN_URL")
        exit(1)
    if TITLE is None:
        print("[-] Invalid TITLE")
        exit(1)
    if VERSION is None:
        print("[-] Invalid VERSION")
        exit(1)


def main():
    print("[+] Uploading to telegram")
    check_environ()
    files = sys.argv[1:]
    print("[+] Files:", files)
    if len(files) <= 0:
        print("[-] No files to upload")
        exit(1)
    
    caption = get_caption()
    print("[+] Caption: ")
    print("---")
    print(caption)
    print("---")
    print("[+] Sending")

    url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendDocument"
    
    for file_path in files:
        with open(file_path, 'rb') as f:
            data = {
                'chat_id': CHAT_ID,
                'caption': caption,
                'parse_mode': 'Markdown',
            }
            if MESSAGE_THREAD_ID:
                data['message_thread_id'] = MESSAGE_THREAD_ID
                
            files_data = {'document': f}
            
            response = requests.post(url, data=data, files=files_data)
            print(f"[+] Response for {file_path}: {response.json()}")
            
    print("[+] Done!")

if __name__ == "__main__":
    main()

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except Exception as e:
        print(f"[-] An error occurred: {e}")
