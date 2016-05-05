"Simple usage of PushBullet API"

import urllib2
import json
import argparse

__author__ = 'VaclavLangr'


def send_message(title, message):
    """
    Method to send message to all devices of user
    :param title: Title of message
    :param message: Body of message
    """
    method = "POST"
    data = {"type": "note", "title": title, "body": message}
    handler = urllib2.HTTPHandler()
    opener = urllib2.build_opener(handler)
    url = 'https://api.pushbullet.com/v2/pushes'
    request = urllib2.Request(url, data=json.dumps(data))
    request.add_header('Content-Type', 'application/json')
    request.add_header('Access-Token', 'o.es3RQGtNJTIRUavlTVxVqzUfpCaw8r8o')
    request.get_method = lambda: method
    opener.open(request)


def parse_args():
    """
    Parser
    """
    parser = argparse.ArgumentParser()
    parser.add_argument("-t", "--title", help="Title")
    parser.add_argument("-b", "--body", help="Body")
    args = parser.parse_args()

    if args.title is not None and args.body is not None:
        send_message(args.title, args.body)

if __name__ == "__main__":
    parse_args()
