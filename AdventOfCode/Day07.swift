//
//  Day07.swift
//  AdventOfCode
//
//  Created by Ahmet Karalar on 06/08/2023.
//

import Foundation
import RegexBuilder

struct Wire {
    let id: String
    let input: Input

    init(id: String, input: Input) {
        self.id = id
        self.input = input
    }
}

enum Input {
    case custom(UInt16)
    case direct(String)
    case gate(Gate)
}

enum Gate {
    case and(String, String)
    case or(String, String)
    case lShift(String, UInt16)
    case rShift(String, UInt16)
    case not(String)
}

class Day07: Solving {
    let valueRegex = Regex {
        Anchor.startOfLine
        Capture {
            OneOrMore(.digit)
        }
        " -> "
        Capture {
            OneOrMore(.word)
        }
        Anchor.endOfLine
    }

    let wireRegex = Regex {
        Anchor.startOfLine
        Capture {
            OneOrMore(.word)
        }
        " -> "
        Capture {
            OneOrMore(.word)
        }
        Anchor.endOfLine
    }


    let andOrRegex = Regex {
        Anchor.startOfLine
        Capture {
            OneOrMore(.word)
        }
        " "
        TryCapture {
            ChoiceOf {
                "AND"
                "OR"
            }
        } transform: { w in
            Command(rawValue: String(w))
        }
        " "
        Capture {
            OneOrMore(.word)
        }
        " -> "
        Capture {
            OneOrMore(.word)
        }
        Anchor.endOfLine
    }

    let shiftRegex = Regex {
        Anchor.startOfLine
        Capture {
            OneOrMore(.word)
        }
        " "
        TryCapture {
            ChoiceOf {
                "LSHIFT"
                "RSHIFT"
            }
        } transform: { w in
            Command(rawValue: String(w))
        }
        " "
        Capture {
            OneOrMore(.digit)
        }
        " -> "
        Capture {
            OneOrMore(.word)
        }
        Anchor.endOfLine
    }

    let notRegex = Regex {
        Anchor.startOfLine
        "NOT "
        Capture {
            OneOrMore(.word)
        }
        " -> "
        Capture {
            OneOrMore(.word)
        }
    }

    lazy var schema: [String: Wire] = {
        var wires: [String: Wire] = [:]
        for line in input.lines {
            if !line.matches(of: valueRegex).isEmpty {
                let (_, signal, outWire) = line.matches(of: valueRegex).first!.output
                let wire = Wire(id: String(outWire), input: .custom(UInt16(signal)!))
                wires[wire.id] = wire
            } else if !line.matches(of: wireRegex).isEmpty {
                let (_, inWire, outWire) = line.matches(of: wireRegex).first!.output
                let wire = Wire(id: String(outWire), input: .direct(String(inWire)))
                wires[wire.id] = wire
            } else if !line.matches(of: andOrRegex).isEmpty {
                let (_, leftWire, action, rightWire, outWire) = line.matches(of: andOrRegex).first!.output

                let gate: Gate = switch action {
                case .and: .and(String(leftWire), String(rightWire))
                case .or: .or(String(leftWire), String(rightWire))
                default: fatalError()
                }

                let wire = Wire(id: String(outWire), input: .gate(gate))
                wires[wire.id] = wire
            } else if !line.matches(of: shiftRegex).isEmpty {
                let (_, inWire, action, shift, outWire) = line.matches(of: shiftRegex).first!.output

                let gate: Gate = switch action {
                case .lShift: .lShift(String(inWire), UInt16(shift)!)
                case .rShift: .rShift(String(inWire), UInt16(shift)!)
                default: fatalError()
                }

                let wire = Wire(id: String(outWire), input: .gate(gate))
                wires[wire.id] = wire
            } else if !line.matches(of: notRegex).isEmpty {
                let (_, inWire, outWire) = line.matches(of: notRegex).first!.output
                let wire = Wire(id: String(outWire), input: .gate(.not(String(inWire))))
                wires[wire.id] = wire
            } else {
                print(line)
                fatalError()
            }
        }

        return wires
    }()

    var signalCache: [String: UInt16] = [:]
    func signal(for wireID: String, wires: [String: Wire]) -> UInt16 {
        if let cached = signalCache[wireID] { return cached }
        guard let wire = wires[wireID] else { fatalError() }
        let signal: UInt16 = switch wire.input {
        case let .custom(signal): signal
        case let .direct(inWire): signal(for: inWire, wires: wires)
        case let .gate(gate):
            switch gate {
            case let .and(left, right):
                if let value = UInt16(left) {
                    value & signal(for: right, wires: wires)
                } else {
                    signal(for: left, wires: wires) & signal(for: right, wires: wires)
                }
            case let .or(left, right):
                if let value = UInt16(left) {
                    value | signal(for: right, wires: wires)
                } else {
                    signal(for: left, wires: wires) | signal(for: right, wires: wires)
                }
            case let .not(inWire):
                if let value = UInt16(inWire) {
                    ~value
                } else {
                    ~signal(for: inWire, wires: wires)
                }
            case let .lShift(inWire, shift): signal(for: inWire, wires: wires) << shift
            case let .rShift(inwire, shift): signal(for: inwire, wires: wires) >> shift
            }
        }
        signalCache[wireID] = signal
        return signal
    }

    func solvePart1() -> String {
        return String(signal(for: "a", wires: schema))
    }

    func solvePart2() -> String {
        let signalA = signal(for: "a", wires: schema)
        schema["b"] = Wire(id: "b", input: .custom(signalA))
        signalCache = [:]
        return String(signal(for: "a", wires: schema))
    }

    enum Command: String {
        case value
        case and = "AND"
        case lShift = "LSHIFT"
        case rShift = "RSHIFT"
        case not = "NOT"
        case or = "OR"
    }

    var input: String {
        """
af AND ah -> ai
NOT lk -> ll
hz RSHIFT 1 -> is
NOT go -> gp
du OR dt -> dv
x RSHIFT 5 -> aa
at OR az -> ba
eo LSHIFT 15 -> es
ci OR ct -> cu
b RSHIFT 5 -> f
fm OR fn -> fo
NOT ag -> ah
v OR w -> x
g AND i -> j
an LSHIFT 15 -> ar
1 AND cx -> cy
jq AND jw -> jy
iu RSHIFT 5 -> ix
gl AND gm -> go
NOT bw -> bx
jp RSHIFT 3 -> jr
hg AND hh -> hj
bv AND bx -> by
er OR es -> et
kl OR kr -> ks
et RSHIFT 1 -> fm
e AND f -> h
u LSHIFT 1 -> ao
he RSHIFT 1 -> hx
eg AND ei -> ej
bo AND bu -> bw
dz OR ef -> eg
dy RSHIFT 3 -> ea
gl OR gm -> gn
da LSHIFT 1 -> du
au OR av -> aw
gj OR gu -> gv
eu OR fa -> fb
lg OR lm -> ln
e OR f -> g
NOT dm -> dn
NOT l -> m
aq OR ar -> as
gj RSHIFT 5 -> gm
hm AND ho -> hp
ge LSHIFT 15 -> gi
jp RSHIFT 1 -> ki
hg OR hh -> hi
lc LSHIFT 1 -> lw
km OR kn -> ko
eq LSHIFT 1 -> fk
1 AND am -> an
gj RSHIFT 1 -> hc
aj AND al -> am
gj AND gu -> gw
ko AND kq -> kr
ha OR gz -> hb
bn OR by -> bz
iv OR jb -> jc
NOT ac -> ad
bo OR bu -> bv
d AND j -> l
bk LSHIFT 1 -> ce
de OR dk -> dl
dd RSHIFT 1 -> dw
hz AND ik -> im
NOT jd -> je
fo RSHIFT 2 -> fp
hb LSHIFT 1 -> hv
lf RSHIFT 2 -> lg
gj RSHIFT 3 -> gl
ki OR kj -> kk
NOT ak -> al
ld OR le -> lf
ci RSHIFT 3 -> ck
1 AND cc -> cd
NOT kx -> ky
fp OR fv -> fw
ev AND ew -> ey
dt LSHIFT 15 -> dx
NOT ax -> ay
bp AND bq -> bs
NOT ii -> ij
ci AND ct -> cv
iq OR ip -> ir
x RSHIFT 2 -> y
fq OR fr -> fs
bn RSHIFT 5 -> bq
0 -> c
14146 -> b
d OR j -> k
z OR aa -> ab
gf OR ge -> gg
df OR dg -> dh
NOT hj -> hk
NOT di -> dj
fj LSHIFT 15 -> fn
lf RSHIFT 1 -> ly
b AND n -> p
jq OR jw -> jx
gn AND gp -> gq
x RSHIFT 1 -> aq
ex AND ez -> fa
NOT fc -> fd
bj OR bi -> bk
as RSHIFT 5 -> av
hu LSHIFT 15 -> hy
NOT gs -> gt
fs AND fu -> fv
dh AND dj -> dk
bz AND cb -> cc
dy RSHIFT 1 -> er
hc OR hd -> he
fo OR fz -> ga
t OR s -> u
b RSHIFT 2 -> d
NOT jy -> jz
hz RSHIFT 2 -> ia
kk AND kv -> kx
ga AND gc -> gd
fl LSHIFT 1 -> gf
bn AND by -> ca
NOT hr -> hs
NOT bs -> bt
lf RSHIFT 3 -> lh
au AND av -> ax
1 AND gd -> ge
jr OR js -> jt
fw AND fy -> fz
NOT iz -> ja
c LSHIFT 1 -> t
dy RSHIFT 5 -> eb
bp OR bq -> br
NOT h -> i
1 AND ds -> dt
ab AND ad -> ae
ap LSHIFT 1 -> bj
br AND bt -> bu
NOT ca -> cb
NOT el -> em
s LSHIFT 15 -> w
gk OR gq -> gr
ff AND fh -> fi
kf LSHIFT 15 -> kj
fp AND fv -> fx
lh OR li -> lj
bn RSHIFT 3 -> bp
jp OR ka -> kb
lw OR lv -> lx
iy AND ja -> jb
dy OR ej -> ek
1 AND bh -> bi
NOT kt -> ku
ao OR an -> ap
ia AND ig -> ii
NOT ey -> ez
bn RSHIFT 1 -> cg
fk OR fj -> fl
ce OR cd -> cf
eu AND fa -> fc
kg OR kf -> kh
jr AND js -> ju
iu RSHIFT 3 -> iw
df AND dg -> di
dl AND dn -> do
la LSHIFT 15 -> le
fo RSHIFT 1 -> gh
NOT gw -> gx
NOT gb -> gc
ir LSHIFT 1 -> jl
x AND ai -> ak
he RSHIFT 5 -> hh
1 AND lu -> lv
NOT ft -> fu
gh OR gi -> gj
lf RSHIFT 5 -> li
x RSHIFT 3 -> z
b RSHIFT 3 -> e
he RSHIFT 2 -> hf
NOT fx -> fy
jt AND jv -> jw
hx OR hy -> hz
jp AND ka -> kc
fb AND fd -> fe
hz OR ik -> il
ci RSHIFT 1 -> db
fo AND fz -> gb
fq AND fr -> ft
gj RSHIFT 2 -> gk
cg OR ch -> ci
cd LSHIFT 15 -> ch
jm LSHIFT 1 -> kg
ih AND ij -> ik
fo RSHIFT 3 -> fq
fo RSHIFT 5 -> fr
1 AND fi -> fj
1 AND kz -> la
iu AND jf -> jh
cq AND cs -> ct
dv LSHIFT 1 -> ep
hf OR hl -> hm
km AND kn -> kp
de AND dk -> dm
dd RSHIFT 5 -> dg
NOT lo -> lp
NOT ju -> jv
NOT fg -> fh
cm AND co -> cp
ea AND eb -> ed
dd RSHIFT 3 -> df
gr AND gt -> gu
ep OR eo -> eq
cj AND cp -> cr
lf OR lq -> lr
gg LSHIFT 1 -> ha
et RSHIFT 2 -> eu
NOT jh -> ji
ek AND em -> en
jk LSHIFT 15 -> jo
ia OR ig -> ih
gv AND gx -> gy
et AND fe -> fg
lh AND li -> lk
1 AND io -> ip
kb AND kd -> ke
kk RSHIFT 5 -> kn
id AND if -> ig
NOT ls -> lt
dw OR dx -> dy
dd AND do -> dq
lf AND lq -> ls
NOT kc -> kd
dy AND ej -> el
1 AND ke -> kf
et OR fe -> ff
hz RSHIFT 5 -> ic
dd OR do -> dp
cj OR cp -> cq
NOT dq -> dr
kk RSHIFT 1 -> ld
jg AND ji -> jj
he OR hp -> hq
hi AND hk -> hl
dp AND dr -> ds
dz AND ef -> eh
hz RSHIFT 3 -> ib
db OR dc -> dd
hw LSHIFT 1 -> iq
he AND hp -> hr
NOT cr -> cs
lg AND lm -> lo
hv OR hu -> hw
il AND in -> io
NOT eh -> ei
gz LSHIFT 15 -> hd
gk AND gq -> gs
1 AND en -> eo
NOT kp -> kq
et RSHIFT 5 -> ew
lj AND ll -> lm
he RSHIFT 3 -> hg
et RSHIFT 3 -> ev
as AND bd -> bf
cu AND cw -> cx
jx AND jz -> ka
b OR n -> o
be AND bg -> bh
1 AND ht -> hu
1 AND gy -> gz
NOT hn -> ho
ck OR cl -> cm
ec AND ee -> ef
lv LSHIFT 15 -> lz
ks AND ku -> kv
NOT ie -> if
hf AND hl -> hn
1 AND r -> s
ib AND ic -> ie
hq AND hs -> ht
y AND ae -> ag
NOT ed -> ee
bi LSHIFT 15 -> bm
dy RSHIFT 2 -> dz
ci RSHIFT 2 -> cj
NOT bf -> bg
NOT im -> in
ev OR ew -> ex
ib OR ic -> id
bn RSHIFT 2 -> bo
dd RSHIFT 2 -> de
bl OR bm -> bn
as RSHIFT 1 -> bl
ea OR eb -> ec
ln AND lp -> lq
kk RSHIFT 3 -> km
is OR it -> iu
iu RSHIFT 2 -> iv
as OR bd -> be
ip LSHIFT 15 -> it
iw OR ix -> iy
kk RSHIFT 2 -> kl
NOT bb -> bc
ci RSHIFT 5 -> cl
ly OR lz -> ma
z AND aa -> ac
iu RSHIFT 1 -> jn
cy LSHIFT 15 -> dc
cf LSHIFT 1 -> cz
as RSHIFT 3 -> au
cz OR cy -> da
kw AND ky -> kz
lx -> a
iw AND ix -> iz
lr AND lt -> lu
jp RSHIFT 5 -> js
aw AND ay -> az
jc AND je -> jf
lb OR la -> lc
NOT cn -> co
kh LSHIFT 1 -> lb
1 AND jj -> jk
y OR ae -> af
ck AND cl -> cn
kk OR kv -> kw
NOT cv -> cw
kl AND kr -> kt
iu OR jf -> jg
at AND az -> bb
jp RSHIFT 2 -> jq
iv AND jb -> jd
jn OR jo -> jp
x OR ai -> aj
ba AND bc -> bd
jl OR jk -> jm
b RSHIFT 1 -> v
o AND q -> r
NOT p -> q
k AND m -> n
as RSHIFT 2 -> at
"""
    }
}

