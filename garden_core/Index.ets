// Public API of the pure rules layer. Export only ArkUI-free symbols: solver code runs in TaskPool
// workers, and any UI import reachable from this file would be pulled into those threads.
