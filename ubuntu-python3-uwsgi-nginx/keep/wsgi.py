def application(env, start_response):
    start_response('200 OK', [('Content-Type','text/plain')])
    return [b"uwsgi says: 'hello, world!'\n"]
