# 파이썬 웹앱(Flask)
# pip install Flask
from flask import Flask, render_template, request
import pymysql

# 변수 초기화
host = 'localhost' # or '127.0.0.1'
port = 3306
database = 'madang'
username = 'root'
password = '12345'

conflag = True # 접속상태

app = Flask(__name__)   # Flask 웹앱 실행

conn = pymysql.connect(host=host, user=username, passwd=password, port=port, database=database)
cursor = conn.cursor()

@app.route('/') # routing decorator : 웹사이트 경로를 실행할 때 http://localhost/5000/
def index():
    query = '''SELECT bookid
                  , bookname
                  , publisher
                  , price 
                 FROM Book'''
    res = cursor.execute(query) # SQL 실행(1회 호출)
    book_list = cursor.fetchall()    # MySQL 데이터를 한 번에 다 가져옴
    # templates 폴더에 있는 html을 데이터와 연결해서 랜더링
    return render_template('booklist.html', book_list=book_list)

@app.route('/view') # http://localhost/5000/view?id=2
def getDetail():
    bookid = request.args.get('id')
    query = f'''SELECT bookid
                  , bookname
                  , publisher
                  , price 
                 FROM Book
                WHERE bookid = '{bookid}'
            '''
    cursor.execute(query)

    data = cursor.fetchall()
    return render_template('bookview.html', book=data)

if __name__ == '__main__':
    app.run('localhost')