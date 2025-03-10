# 학생정보 등록 GUI 앱
# pip install pymysql

# 1. 관련 모듈 import
import tkinter as tK
from tkinter import * # tkinter는 이걸로 모든 모듈을 부를 수 없음
from tkinter import ttk, messagebox
from tkinter.font import *  # 기본 외 폰트 사용 모듈

import pymysql # mysql-connector 등 다른 모듈도 사용 가능

# 2. DB 관련 설정
host = 'localhost' # 127.0.0.1과 동일
port = 3306
database = 'madang'
username = 'madang'
password = 'madang'

# 5. DB 처리 함수 정의
## 5-1. showDatas() - DB 학생정보 테이블의 데이터를 가져와서 TreeView에 표시
def showDatas():
    '''
    데이터베이스 내 모든 학생정보를 가져와 표시하는 사용자 함수\n
    매개변수 필요 없음
    '''
    global dataView # 전역변수 사용
    ### DB 연결. 커넥션 객체 생성 -> 커서 생성 -> 쿼리 실행 -> 커서로 데이터 패치 -> 커서 종료 -> 커넥션 종료
    conn = pymysql.connect(host=host, user=username, passwd=password, port=port, db=database)
    cursor = conn.cursor()  # DB 쿼리 실행 시 커서 생성해야함

    # 쿼리문 작성
    query = 'SELECT std_id, std_name, std_mobile, std_regyear FROM students'
    cursor.execute(query=query) # query 실행
    data = cursor.fetchall()    # query 실행 데이터 전부 가져옴

    # 가져온 데이터 트리뷰에 추가
    print(data)
    dataView.delete(*dataView.get_children())     # 최초, 중간에 showDatas() 호출할때마다 트리뷰 클리어
    for i, (std_id, std_name, std_mobile, std_regyear) in enumerate(data, start=1): # enumerate - 인덱스와 아이템 동시 접근
        dataView.insert('', 'end', values=(std_id, std_name, std_mobile, std_regyear))  # 트리뷰 마지막 'end'추가

    cursor.close()  # 커서 종료
    conn.close()    # 커넥션 종료

# 6. getData(event) - 트리뷰 한 줄 더블클릭한 값 엔트리에 표시
def getData(event):
    '''
    트리뷰 더블클릭으로 선택된 학생정보를 엔트리 위젯에 채우는 사용자 정의 함수

    Args:
        event: 트리뷰에 발생하는 이벤트 객체
    '''
    global ent1, ent2, ent3, ent4, dataView     # 전역변수 사용

    # 엔트리 위젯 기존 내용 삭제
    ent1.delete(0, END) # 학생번호 기존 데이터 삭제
    ent2.delete(0, END) # 학생명 기존 데이터 삭제
    ent3.delete(0, END) # 휴대폰 기존 데이터 삭제
    ent4.delete(0, END) # 입학년도 기존 데이터 삭제

    # 트리뷰 선택항목 ID 가져오기('I001')
    sel_item = dataView.selection()

    if sel_item:
        item_values = dataView.item(sel_item, 'values') # 선택항목 'values'(실제 데이터) 가져오기

    # 엔트리 위젯에 각각 채워넣기
    ent1.config(state='normal')     # 데이터 들어갈 수 있게 해주고
    ent1.insert(0, item_values[0])  # 학생번호
    ent1.config(state='readonly')   # 다시 수정 못하도록
    ent2.insert(1, item_values[1])  # 학생명
    ent3.insert(2, item_values[2])  # 휴대폰
    ent4.insert(3, item_values[3])  # 입학년도

# 7. 새 학생정보 추가 함수
def addData():
    '''
    새 학생정보 DB 테이블에 추가하는 사용자 정의 함수
    '''
    global ent1, ent2, ent3, ent4, dataView     # 전역변수 사용

    # 엔트리 위젯 학생정보데이터 변수에 할당
    std_name = ent2.get()   # 학생명
    std_mobile = ent3.get()   # 휴대폰
    std_regyear = ent4.get()   # 입학년도

    # DB 연결
    conn = pymysql.connect(host=host, user=username, passwd=password, port=port, db=database)
    cursor = conn.cursor()  # DB 쿼리 실행 시 커서 생성해야함

    try:
        conn.begin()    # BEGIN TRANSACTION. 트랜잭션 시작
        # 쿼리 작성
        query = 'INSERT INTO students (std_name, std_mobile, std_regyear) VALUES (%s, %s, %s)'
        val = (std_name, std_mobile, std_regyear)
        cursor.execute(query=query, args=val)   # 쿼리 실행

        conn.commit()   # 트랜잭션 확정
        lastid = cursor.lastrowid   # 마지막에 insert된 레코드 id를 가져옴
        print(lastid)

        messagebox.showinfo('INSERT', '학생등록 성공')

        ent1.config(state='normal')     # 데이터 들어갈 수 있게 해주고
        ent1.delete(0, END) # 학생번호 기존 데이터 삭제
        ent1.config(state='readonly')     # 데이터 들어갈 수 있게 해주고
        ent2.delete(0, END) # 학생명 기존 데이터 삭제
        ent3.delete(0, END) # 휴대폰 기존 데이터 삭제
        ent4.delete(0, END) # 입학년도 기존 데이터 삭제
        ent2.focus_set()    # 학생명에 포커스

    except Exception as e:
        print(e)
        conn.rollback() # 트랜잭션 롤백
        messagebox.showerror('INSERT', '학생등록 실패')
    finally:
        cursor.close()  # 커서 종료
        conn.close()    # 커넥션 종료
    showDatas()     # DB 테이블의 모든 데이터 조회

# 8. 기존 학생정보 수정
def modData():
    '''
    기존 학생정보 수정하는 사용자 정의 함수
    '''
    global ent1, ent2, ent3, ent4, dataView     # 전역변수 사용

    # 엔트리 위젯 학생정보데이터 변수에 할당
    std_id = ent1.get()       # 학생번호
    std_name = ent2.get()     # 학생명
    std_mobile = ent3.get()   # 휴대폰
    std_regyear = ent4.get()  # 입학년도

    if std_id == '':
        messagebox.showwarning('UPDATE', '수정할 데이터를 선택')
        return

    # DB 연결
    conn = pymysql.connect(host=host, user=username, passwd=password, port=port, db=database)
    cursor = conn.cursor()  # DB 쿼리 실행 시 커서 생성해야함

    try:
        conn.begin()    # BEGIN TRANSACTION. 트랜잭션 시작
        # 쿼리 작성
        query = 'UPDATE students SET std_name=%s, std_mobile=%s, std_regyear=%s WHERE std_id=%s'
        val = (std_name, std_mobile, std_regyear, std_id)
        cursor.execute(query=query, args=val)   # 쿼리 실행

        conn.commit()   # 트랜잭션 확정
        lastid = cursor.lastrowid   # 마지막에 insert된 레코드 id를 가져옴
        print(lastid)

        messagebox.showinfo('UPDATE', '수정 성공')

        ent1.config(state='normal')     # 데이터 들어갈 수 있게 해주고
        ent1.delete(0, END) # 학생번호 기존 데이터 삭제
        ent1.config(state='readonly')     # 데이터 들어갈 수 있게 해주고
        ent2.delete(0, END) # 학생명 기존 데이터 삭제
        ent3.delete(0, END) # 휴대폰 기존 데이터 삭제
        ent4.delete(0, END) # 입학년도 기존 데이터 삭제
        ent2.focus_set()    # 학생명에 포커스

    except Exception as e:
        print(e)
        conn.rollback() # 트랜잭션 롤백
        messagebox.showerror('INSERT', '수정 실패')
    finally:
        cursor.close()  # 커서 종료
        conn.close()    # 커넥션 종료
    showDatas()     # DB 테이블의 모든 데이터 조회

# 9. 기존 학생정보 삭제
def delData():
    '''
    기존 학생정보 삭제하는 사용자 정의 함수
    '''
    global ent1, ent2, ent3, ent4, dataView     # 전역변수 사용

    # 엔트리 위젯 학생정보데이터 변수에 할당
    std_id = ent1.get()       # 학생번호

    if std_id == '':
        messagebox.showwarning('UPDATE', '수정할 데이터를 선택')
        return

    # DB 연결
    conn = pymysql.connect(host=host, user=username, passwd=password, port=port, db=database)
    cursor = conn.cursor()  # DB 쿼리 실행 시 커서 생성해야함

    try:
        conn.begin()    # BEGIN TRANSACTION. 트랜잭션 시작
        # 쿼리 작성
        query = 'DELETE FROM students WHERE std_id=%s'
        val = (std_id)
        cursor.execute(query=query, args=val)   # 쿼리 실행

        conn.commit()   # 트랜잭션 확정
        lastid = cursor.lastrowid   # 마지막에 insert된 레코드 id를 가져옴
        print(lastid)

        messagebox.showinfo('UPDATE', '삭제 성공')

        ent1.config(state='normal')     # 데이터 들어갈 수 있게 해주고
        ent1.delete(0, END) # 학생번호 기존 데이터 삭제
        ent1.config(state='readonly')     # 데이터 들어갈 수 있게 해주고
        ent2.delete(0, END) # 학생명 기존 데이터 삭제
        ent3.delete(0, END) # 휴대폰 기존 데이터 삭제
        ent4.delete(0, END) # 입학년도 기존 데이터 삭제
        ent2.focus_set()    # 학생명에 포커스

    except Exception as e:
        print(e)
        conn.rollback() # 트랜잭션 롤백
        messagebox.showerror('DELETE', '삭제 실패')
    finally:
        cursor.close()  # 커서 종료
        conn.close()    # 커넥션 종료
    showDatas()     # DB 테이블의 모든 데이터 조회


# 3. tkinter UI 윈도우 설정
root = Tk()                     # tkinter 윈도우 인스턴스 생성
root.geometry('820x500')        # 윈도우 크기 지정
root.title('학생정보 등록앱')   # 윈도우 타이틀 지정
root.resizable(False, False)    # 윈도우 사이즈 변경 불가
root.iconbitmap('./images/students.ico')

myFont = Font(family='NanumGothic', size=10)    # 이후에 화면 위젯에 지정할 동일 폰트 생성

# 4. UI 구성
## 4-1
# 레이블
tK.Label(root, text='학생번호', font=myFont).place(x=10, y=10)
tK.Label(root, text='학생명', font=myFont).place(x=10, y=40)
tK.Label(root, text='휴대폰', font=myFont).place(x=10, y=70)
tK.Label(root, text='입학년도', font=myFont).place(x=10, y=100)

## 4-2
# 엔트리(텍스트박스)
ent1 = tK.Entry(root, font=myFont)  # 학생번호 Entry
ent1.config(state='readonly', foreground='blue', disabledforeground='blue')       # 값을 입력 못하게 막아줌
ent1.place(x=140, y=10)
ent2 = tK.Entry(root, font=myFont)  # 학생명 Entry
ent2.place(x=140, y=40)
ent3 = tK.Entry(root, font=myFont)  # 휴대폰 Entry
ent3.place(x=140, y=70)
ent4 = tK.Entry(root, font=myFont)  # 입학년도 Entry
ent4.place(x=140, y=100)

## 4-3
# 버튼
# 7-1. 추가버튼에 addData() 함수 연결
# 8-1. 수정버튼에 modData() 함수 연결
# 9-1. 삭제버튼에 delData() 함수 연결
tK.Button(root, text='추가', font=myFont, height=2, width=12, command=addData).place(x=30, y=130)     # 추가버튼
tK.Button(root, text='수정', font=myFont, height=2, width=12, command=modData).place(x=140, y=130)    # 추가버튼
tK.Button(root, text='삭제', font=myFont, height=2, width=12, command=delData).place(x=250, y=130)    # 추가버튼

## 4-4
# 트리뷰(행과 열로 만들어진 데이터 표현할 때 좋은 위젯 중 하나)
cols = ('학생번호', '학생명', '휴대폰', '입학년도')
dataView = ttk.Treeview(root, columns=cols, show='headings', height=14)

## 4-5
# 트리뷰 설정
for col in cols:
    dataView.heading(col, text=col)                 # 각 열의 제목에 cols 변수 하나씩 지정
    dataView.grid(row=1, column=0, columnspan=2)    # 트리뷰 위젯을 그리드 레이아웃에 배치
    dataView.place(x=10, y=180)                     # 트리뷰 위젯 배치

# 5. showDatas() 호출
showDatas()

# 6. 트리뷰 항목 더블클릭하면 이벤트 발생(getData() 함수 호출)
dataView.bind('<Double-Button-1>', func=getData)

# 10. 최초 실행 시 ent2에 포커스
ent2.focus_set()

# 3. 앱 실행
root.mainloop()