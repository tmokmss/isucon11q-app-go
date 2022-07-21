package main

import "sync"

type cacheSlice struct {
	// Setが多いならsync.Mutex
	sync.RWMutex
	items map[string]int
}

func NewCacheSlice() *cacheSlice {
	m := make(map[string]int)
	c := &cacheSlice{
		items: m,
	}
	return c
}

func (c *cacheSlice) Set(key string, value int) {
	c.Lock()
	c.items[key] = value
	c.Unlock()
}

func (c *cacheSlice) Get(key string) (int, bool) {
	c.RLock()
	v, found := c.items[key]
	c.RUnlock()
	return v, found
}

func (c *cacheSlice) Incr(key string, n int) {
	c.Lock()
	v, found := c.items[key]
	if found {
		c.items[key] = v + n
	} else {
		c.items[key] = n
	}
	c.Unlock()
}

var mCache = NewCacheSlice()
