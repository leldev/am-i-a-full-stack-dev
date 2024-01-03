"use client";

import { useEffect, useState } from "react";
import AceEditor from "react-ace";
import { useRecoilState } from "recoil";
import useGetPersons from "@/api/getPersons";
import { personsState } from "@/states/personsState";
import {isEmpty} from 'lodash';

import "ace-builds/src-noconflict/mode-json";
import "ace-builds/src-noconflict/theme-github_dark";
import "ace-builds/src-noconflict/ext-language_tools";

const JsonResume = (): JSX.Element => {
  const [loading, setIsLoading] = useState(true);

  const { getPersons } = useGetPersons();
  const [clients] = useRecoilState(personsState);

  useEffect(() => {
    void loadPersons();
  }, []);

  const loadPersons = async () => {
    await getPersons();
    setIsLoading(false);
  };

  if (loading) {
    return <span className="loading loading-ring text-warning w-44" />;
  }

  const noResult = {error: 'No result'};

  return (
    <AceEditor
      mode="json"
      theme="github_dark"
      name="resume"
      fontSize={14}
      showPrintMargin={true}
      showGutter={true}
      highlightActiveLine={true}
      value={JSON.stringify(isEmpty(clients)? noResult : clients[0], null, 2)}
      readOnly={false}
      width="100%"
      setOptions={{
        enableBasicAutocompletion: false,
        enableLiveAutocompletion: false,
        enableSnippets: false,
        showLineNumbers: true,
        tabSize: 2,
      }}
    />
  );
};

export default JsonResume;
