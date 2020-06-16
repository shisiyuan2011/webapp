function verify_token() {
    if (Vue.$cookies.get('access_token') == null
         || Vue.$cookies.get('token_type') == null) {
        document.location='/';
    } else {
        const headers = {
            'Accept': 'application/json',
            'Authorization': ' ' + Vue.$cookies.get('token_type')
                                 + ' ' + Vue.$cookies.get('access_token')
        };

        console.log(headers.Authorization);
        axios
        .get('/users/me', {headers})
        .then(res => {
            Vue.$cookies.set('access_token', res.data.refresh_token);
            console.log(res);
        })
        .catch(err => {
            document.location='/';
        });
    }      
}