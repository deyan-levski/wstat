import time

NUM_CYCLES = 10
start = time.time()
for impulse_count in range(NUM_CYCLES):
    GPIO.wait_for_edge(25, GPIO.FALLING)
duration = time.time() - start      #seconds to run for loop
frequency = NUM_CYCLES / duration   #in Hz
