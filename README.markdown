Riaque
======

Process background jobs persisted in Riak.

Motivation
==========

Usage 
=====

First, define a job.  A job has a perform method, and optionally
specifies the queue it should live in.

```ruby
class VectorJob
  @queue = :vectors

  def self.perform(x, y) 
    [x,y]
  end
end
```

License
=======

Riaque is Copyright © 2011 Critical Pair.  Riaque is free software, and may be redistributed under the terms specified in the LICENSE file.
