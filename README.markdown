# Riaque

Process background jobs persisted in Riak.

## Motivation

Riaque provides a high availability, eventual consistency, job queueing system that places importance on the ability to enqueue jobs and have them persisted over the ability to work them as soon as they are queued.  Riaque also assumed that jobs are unique based on their type and argument list, and are idempotent.  Riaque was built to replace Resque in the Overriak service.

## Usage 

### Jobs

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

### Enqueue 

Execute the following to enqueue one VectorJob.  When this job is worked, 
it will call the perform method on VectorJob with the argument list supplied.

```ruby 
Riaque.enqueue(VectorJob, 1, 1)
```

Enqueuing results in a couple of operations:

* The creation of a job object in Riak, with a key derived from the class of the job, and it's payload.  This ensures that queueing of the same job multiple times results in one Riak object.
* The insertion of the job's key into a Queue object (and the creation of that Queue if it does not exist yet.)

### Dequeue 

Execute the following to dequeue a specific job.  Assuming the job above has been queued already, execute the following:

```ruby
Riaque.dequeue(VectorJob, 1, 1)
```

Dequeueing will result in the removal of all instances of that particular job in the queue, but will not remove the job object.

### Execution of jobs

Assuming the job above has been queued, when it comes time for the job to be worked, something like the following will be executed:

```ruby
VectorJob.perform(1,1)
```

### Conflicts

In the event of conflicts due to divergent vector clocks, which is most likely to occur when dealing with queue management, Riaque will merge the job lists of the sibling objects together and resave the queue.

### Compatibility

Riaque attempts to preserve the interface of Resque and Delayed Job as much as possible, allowing for jobs classes to be defined and enqueued into any of them through the same public interface.  If you see somewhere that we've derived from that, please let us know!

## Contributing

1. Fork the [official repository](http://github.com/criticalpair/riaque/tree/master).
2. Make your changes in a topic branch.
3. Send a pull request.

Notes:

* Contributions without tests won't be accepted.
* Please don't update the Gem version.

## License

Riaque is Copyright © 2011 Critical Pair.  Riaque is free software, and may be redistributed under the terms specified in the LICENSE file.
