//
// Created by ignat on 20/06/22.
//

#ifndef DUNE2000_BLOCKING_QUEUE_H
#define DUNE2000_BLOCKING_QUEUE_H

#include <mutex>
#include <condition_variable>
#include <queue>
#include <memory>

template<class T>
class BlockingQueue {
	std::queue<T> q;
	std::mutex mtx;
	std::condition_variable cv;

public:
	BlockingQueue();

	/*
	 * Los elementos T deben ser movibles
	 */
	void push(const T &val);
	void push(T &&val);

	/*
	 * Devuelve el elemento al frente de la cola
	 * por move semantics y hace un pop
	 */
	T pop();

	/*
	 * Devuelve un puntero a null si la cola esta vacia
	 */
	std::shared_ptr<T> try_pop();

	~BlockingQueue();

	BlockingQueue(const BlockingQueue<T>& other) = delete;
	BlockingQueue& operator=(const BlockingQueue<T>& other) = delete;

private:
	bool empty() const;
};

template<class T>
BlockingQueue<T>::BlockingQueue(){}

template<class T>
bool BlockingQueue<T>::empty() const
{
	return this->q.empty();
}

template<class T>
void BlockingQueue<T>::push(const T &val)
{
	std::unique_lock<std::mutex> lck(this->mtx);
	this->q.push(val);
	this->cv.notify_all();
}

template<class T>
void BlockingQueue<T>::push(T &&val)
{
	std::unique_lock<std::mutex> lck(this->mtx);
	this->q.push(val);
	this->cv.notify_all();
}

template<class T>
T BlockingQueue<T>::pop()
{
	std::unique_lock<std::mutex> lck(this->mtx);
	while (this->empty())
		this->cv.wait(lck);

	T val = std::move(this->q.front());
	this->q.pop();
	return std::move(val);
}

template<class T>
std::shared_ptr<T> BlockingQueue<T>::try_pop()
{
	std::lock_guard<std::mutex> lck(this->mtx);
	if (this->empty())
		return std::shared_ptr<T>();

	std::shared_ptr<T> ptr = std::make_shared<T>(std::move(this->q.front()));
	this->q.pop();
	return ptr;
}

template<class T>
BlockingQueue<T>::~BlockingQueue() = default;

#endif //DUNE2000_BLOCKING_QUEUE_H
