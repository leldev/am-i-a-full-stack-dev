import axios from "axios";

const ApiService = () => {
    const request = async <T>(path: string, options: HttpOptions, token?: string): Promise<T> => {
        if (token) {
            options.headers = {
                ...options.headers,
                Authorization: `Bearer ${token}`
            };
        }

        const url =
            process.env.NEXT_PUBLIC_ENV === "local"
                ? `${process.env.NEXT_PUBLIC_API}/${path}`
                : `${location.origin}/api/${path}`;

        return await axios({
            url: url,
            method: options.method,
            headers: {
                "Content-Type": "application/json",
                Accept: "application/json",
                ...options.headers
            },
            data: options.data
        }).then((res) => res.data);
    };

    return { request };
};

export enum HTTP_METHOD {
    GET = "get",
    POST = "post",
    PUT = "put",
    PATCH = "patch",
    DELETE = "delete"
}

interface HttpOptions {
    method: HTTP_METHOD;
    data?: any;
    headers?: any;
}

export default ApiService;
