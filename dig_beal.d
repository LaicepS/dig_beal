#!/usr/bin/rdmd --shebang -unittest -g

import std.algorithm.searching;
import std.random;
import std.range;
import std.string;
import std.stdio;
import std.typecons;

Random g_random;

static this()
{
  g_random = Random(unpredictableSeed);
}

int main()
{
  const winWithChange = iota(10_000).count!((int) => carFound(Yes.changeDoor));
  const winWithoutChange = iota(10_000).count!((int n) => carFound(No.changeDoor));

  writefln("Victoires en changeant: %s", winWithChange); 
  writefln("Victoires sans changer: %s", winWithoutChange); 

  return 0;
}

bool carFound(Flag!"changeDoor" changeDoor)
{
  const setup = newInitialSetup();
  if (!changeDoor)
    return setup.doors[setup.selectIdx];

  const removeIdx = falseIdx(setup.doors, setup.selectIdx);

  assert(!setup.doors[removeIdx] && removeIdx != setup.selectIdx);

  const firstFreeIdx = iota(setup.doors.length).find!((size_t i) => i != setup.selectIdx && i != removeIdx)[0];
  return setup.doors[firstFreeIdx];
}

InitialSetup newInitialSetup()
{
  bool[3] doors;

  const carIdx = randomIdx(doors);
  doors[carIdx] = true;

  const selectIdx = randomIdx(doors);
  return InitialSetup(doors, selectIdx);
}

struct InitialSetup
{
  bool[3] doors;
  size_t selectIdx;
}

unittest
{
  assert(randomIdx([0, 0, 0]) < [0, 0, 0].length);
  assert(randomIdx([0, 0, 0]) >= 0);
}

auto randomIdx(T)(T[] tab)
{
  return uniform(0, tab.length, g_random);
}

size_t falseIdx(in bool[] tab, size_t takenIdx)
{
  return iota(tab.length).find!((size_t idx) => !tab[idx] && idx != takenIdx)[0];
}
