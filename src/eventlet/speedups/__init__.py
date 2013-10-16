import imp
import sys


def _modules_to_patch():
    from eventlet.speedups import greenio
    yield ('eventlet.greenio', greenio)

    from eventlet.speedups import semaphore
    yield ('eventlet.semaphore', semaphore)

    from eventlet.speedups import queue
    yield ('eventlet.queue', queue)

    from eventlet.speedups import timeout
    yield ('eventlet.timeout', timeout)

    from eventlet.speedups.hubs import hub
    yield ('eventlet.hubs.hub', hub)

    from eventlet.speedups.hubs import timer
    yield ('eventlet.hubs.hub', hub)

    #from eventlet.speedups.hubs import poll
    #yield ('eventlet.hubs.poll', poll)

    from eventlet.speedups.hubs import trampoline
    yield ('eventlet.hubs._threadlocal', trampoline._threadlocal)
    yield ('eventlet.hubs.use_hub', trampoline.use_hub)
    yield ('eventlet.hubs.get_hub', trampoline.get_hub)
    yield ('eventlet.hubs.get_default_hub', trampoline.get_default_hub)
    yield ('eventlet.hubs.trampoline', trampoline.trampoline)


def install():
    imp.acquire_lock()
    try:
        for name, topatch in _modules_to_patch():
            name, attr = name.rsplit('.', 1)
            orig_mod = sys.modules.get(name)
            if orig_mod is None:
                orig_mod = __import__(name)
            setattr(orig_mod, attr, topatch)
    finally:
        imp.release_lock()
