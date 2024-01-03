import { useRecoilState } from "recoil";
import ApiService, { HTTP_METHOD } from "@/services/apiService";
import { Person } from "@/types/person";
import { personsState } from "@/states/personsState";

export const useGetPersons = () => {
  const { request } = ApiService();
  const [, setPersons] = useRecoilState(personsState);

  const getPersons = async () => {
    const data = await request<Person[]>("persons", {
      method: HTTP_METHOD.GET,
    });

    setPersons(data);
  };

  return { getPersons };
};

export default useGetPersons;
