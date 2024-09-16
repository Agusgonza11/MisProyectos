//
// Created by lucas on 26/06/22.
//

#include "Thread.h"

Thread::Thread() = default;

Thread::~Thread() = default;

void Thread::start() {
    thread = std::thread(&Thread::run, this);
}

Thread::Thread(Thread &&thread1) {
    this->thread = std::move(thread1.thread);
}

Thread &Thread::operator=(Thread &&thread1) {
    this->thread = std::move(thread1.thread);
    return *this;
}

void Thread::join() {
    thread.join();
}
