import os
import uuid
import psycopg2
import psycopg2.extras
from flask import Flask, session
from flask.ext.socketio import SocketIO, emit

app = Flask(__name__, static_url_path='')
app.config['SECRET_KEY'] = 'secret!'

socketio = SocketIO(app)

messages = [{'text':'test', 'name':'testName'}]
users = {}

def connectToDB():
  connectionString = 'dbname=chatroom user=postgres password=beatbox host=localhost'
  try:
    return psycopg2.connect(connectionString)
  except:
    print("Can't connect to database")


def updateRoster():
    names = []
    for user_id in  users:
        print users[user_id]['username']
        if len(users[user_id]['username'])==0:
            names.append('Anonymous')
        else:
            names.append(users[user_id]['username'])
    print 'broadcasting names'
    emit('roster', names, broadcast=True)
    

@socketio.on('connect', namespace='/chat')
def test_connect():
    session['uuid']=uuid.uuid1()
    session['username']='starter name'
    print 'connected'
    
    users[session['uuid']]={'username':'New User'}
    updateRoster()
    
    conn = connectToDB()
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    
    query = "SELECT message, username FROM messages join users on (id = user_id)"
    cur.execute(query)
    results = cur.fetchall()

    messages = []
    
    for result in results:
        tmp = {'text': result['message'], 'name': result['username']}
        messages.append(tmp)

    for message in messages:
        emit('message', message)

@socketio.on('message', namespace='/chat')
def new_message(message):
    #tmp = {'text':message, 'name':'testName'}
    tmp = {'text':message, 'name':users[session['uuid']]['username']}
    messages.append(tmp)
    
    conn = connectToDB()
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    
    userId = session['id']
    
    #Insert new message into database
    try:
        query = "INSERT INTO messages (user_id, message) VALUES (%s, %s)"
        cur.execute(query, (userId, message))
    except:
        print("ERROR inserting into messages")
        
    conn.commit()
    
    emit('message', tmp, broadcast=True)
    
@socketio.on('identify', namespace='/chat')
def on_identify(message):
    print 'identify ' + message
    users[session['uuid']]={'username':message}
    updateRoster()


@socketio.on('login', namespace='/chat')
def on_login(loginInfo):
    conn = connectToDB()
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    showhide = ""
    loginMessage = ""
    
    #Just used to check if information is correct.
    print 'login '  + loginInfo['username'] + " " + loginInfo['password']
    
    #sets variables with login information
    username = loginInfo['username']
    pw = loginInfo['password']
    
    #Login query
    query = "SELECT id, username, password FROM users WHERE username = %s AND password = crypt(%s, password)"
    cur.execute(query, (username, pw))
    results = cur.fetchone()
    
    if results:
        users[session['uuid']]={'username':username}
        session['id'] = results[0]
        session['username'] = results[1]
        updateRoster()
        showhide = "hide"
        loginMessage = "Login was successful"
        emit('loginCheck', loginMessage, showhide)
        print "Login complete"
    else:
        loginMessage = "The login information was incorect"
        showhide = "show"
        emit('loginCheck', loginMessage, showhide)
        print "The login information was incorrect"


    
@socketio.on('disconnect', namespace='/chat')
def on_disconnect():
    print 'disconnect'
    if session['uuid'] in users:
        del users[session['uuid']]
        updateRoster()

@app.route('/')
def hello_world():
    print 'in hello world'
    return app.send_static_file('index.html')
    #return 'Hello World!'

@app.route('/js/<path:path>')
def static_proxy_js(path):
    # send_static_file will guess the correct MIME type
    return app.send_static_file(os.path.join('js', path))
    
@app.route('/css/<path:path>')
def static_proxy_css(path):
    # send_static_file will guess the correct MIME type
    return app.send_static_file(os.path.join('css', path))
    
@app.route('/img/<path:path>')
def static_proxy_img(path):
    # send_static_file will guess the correct MIME type
    return app.send_static_file(os.path.join('img', path))
    
if __name__ == '__main__':
    print "A"

    socketio.run(app, host=os.getenv('IP', '0.0.0.0'), port=int(os.getenv('PORT', 8080)))
     