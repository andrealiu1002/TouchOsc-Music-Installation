from mmm_audio import *

struct FM_02_03(Movable, Copyable):
    var world: UnsafePointer[MMMWorld]
    var car: Osc[1, Interp.sinc, 1]
    var mod: Osc[1, Interp.sinc, 1]

    var fb: MFloat[1]
    var m: Messenger

    var mod_mul: MFloat[1]
    var freq_car: MFloat[1]
    var freq_mod: MFloat[1]
    var feedback: MFloat[1]
    var button1: MFloat[1]

    fn __init__(out self, world: UnsafePointer[MMMWorld]):
        self.world = world
        self.car = Osc[1, Interp.sinc, 1](world)
        self.mod = Osc[1, Interp.sinc, 1](world)
        self.fb = 0.0

        self.mod_mul = MFloat[1](0.0)
        self.freq_car = MFloat[1](460.0)
        self.freq_mod = MFloat[1](240.0)
        self.feedback = MFloat[1](0.0)
        self.m = Messenger(world)
        self.button1 = MFloat[1](0.0)


    fn next(mut self) -> MFloat[2]:
        self.m.update(self.mod_mul, "mod_mul")
        self.m.update(self.freq_car, "freq_car")
        self.m.update(self.freq_mod, "freq_mod")
        self.m.update(self.button1, "button1")

        var current_type = OscType.sine
        if self.button1[0] > 0.5:
            current_type = OscType.saw
        
        var mod_sig = self.mod.next(self.freq_mod[0], osc_type = current_type) * self.mod_mul[0]
        var out = self.car.next(self.freq_car[0] + mod_sig, osc_type = current_type)

        return out * 0.2
        

