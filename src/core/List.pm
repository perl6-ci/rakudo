class Parcel { ... }

class List {
    # Has attributes and parent Iterable declared in BOOTSTRAP

    method Bool() { self.gimme(1).Bool }

    method flat() { self }

    method elems() {
        my $n = self.gimme(*);
        $!rest
          ?? pir::perl6_box_num__PN('Inf')
          !! $n;
    }

    method exists(\$pos) {
        self.gimme($pos+1);
        pir::perl6_booleanize__PI(
            pir::exists__IQI($!items, pir::repr_unbox_int__IP($pos))
        )
    }

    method gimme(\$n) {
        pir::defined($!items) ||
            pir::setattribute__vPPsP(self, List, '$!items',
                                     pir::new__Ps('ResizablePMCArray'));
        my $i = pir::perl6_box_int__PI(pir::elements($!items));
        my $x;
        my $eager = Whatever.ACCEPTS($n);
        while $!rest && ($eager || $i < $n) {
            $x := pir::shift__PP($!rest);
            if Parcel.ACCEPTS($x) {
                pir::splice__vPPii(
                     $!rest, pir::getattribute__PPPs($x, Parcel, '$!storage'),
                     0, 0);
            }
            else {
                self.BIND_POS($i, $x);
                $i = $i + 1;
            }
        }
        pir::perl6_box_int__PI(pir::elements($!items));
    }

    method join(\$sep = '') {
        pir::perl6_box_str__PS(pir::join__SsP($sep, $!items));
    }

    method list() { self }

    method shift() {
        self.gimme(1) && pir::shift__PP($!items);
    }

    method at_pos(\$pos) {
        self.exists($pos)
          ?? pir::set__PQi($!items, pir::repr_unbox_int__IP($pos))
          !! Any
    }

    method Str() {
        self.join(' ');
    }

    method BIND_POS(\$pos, \$v) {
        pir::set__2QiP($!items, pir::repr_unbox_int__IP($pos), $v)
    }
}

