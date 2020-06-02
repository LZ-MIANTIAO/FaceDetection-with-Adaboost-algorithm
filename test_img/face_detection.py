import cv2
import time

# if you get error when running the following code, maybe you should change the relative paths to absolute paths.
if __name__ == '__main__':

    # load cascade classifier training file for haarcascade
    face_cascade = cv2.CascadeClassifier('./haarcascade_frontalface_default.xml')

    start_time = time.time()
    # load test image
    # img = cv2.imread('./Lena.png')
    img = cv2.imread('./45.jpg')


    # convert the test image to gray image as opencv face detector expects gray images
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # detect
    faces = face_cascade.detectMultiScale(gray, 1.3, 5)

    # draw the detected faces in the test image
    for (x,y,w,h) in faces:
        cv2.rectangle(img, (x,y), (x+w, y+h), (255, 0, 0), 2)

    # show and save the result
    cv2.imshow('img', img)
    print("检测时间 :",time.time() - start_time, sep = '')
    cv2.imwrite('./result1.jpg', img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
    

