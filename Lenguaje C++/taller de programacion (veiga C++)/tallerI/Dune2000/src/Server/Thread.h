//
// Created by lucas on 26/06/22.
//

#ifndef SERVER_THREAD_H
#define SERVER_THREAD_H


#include <thread>

class Thread {
private:
    std::thread thread;
public:
    Thread();
    virtual ~Thread();
    virtual void run() = 0;
    virtual void stop() = 0;
    void start();
    void join();
    Thread(const Thread&) = delete;
    Thread& operator=(const Thread&) = delete;
    Thread(Thread&& thread1);
    Thread& operator=(Thread&& thread1);
};


#endif //SERVER_THREAD_H
