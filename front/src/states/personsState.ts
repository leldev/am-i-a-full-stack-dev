import { atom } from 'recoil';
import { Person } from '@/types/person';

export const personsState = atom<Person[]>({
    key: 'personsState',
    default: []
});
