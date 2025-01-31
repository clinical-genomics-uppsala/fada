# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Pádraic Corcoran"
__copyright__ = "Copyright 2024, Pádraic Corcoran"
__email__ = "padraic.corcoran@sciliflab.uu.se"
__license__ = "GPL-3"


def test_dummy():
    from dummy import dummy
    assert dummy() == 1