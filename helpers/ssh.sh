usage()
{
    printf """<Usage> ./ssh.sh <option>
          --torify-all      [ all connections for ssh will be through tor        ]
          --torify-one      [ only the connection specified will be through tor  ]
          --torify-more     [ only the connections specified will be through tor ]
          \n"""
}

torify_one()
{
    printf "Alias: "
    read alias
    printf "Target Domain/IP: "
    read target
    printf "User: "
    read user
    printf "Public Key Path(optional): "
    read key

    if [ $key ];then
        printf "\nHost $alias\n\tHostName $target\n\tUser $user\n\tIdentityFile $key\n" >> ~/.ssh/config
        printf "\tCheckHostIP no\n\tCompression yes\n\tProtocol 2\n" >> ~/.ssh/config
        printf "\tProxyCommand connect -4 -S localhost:9050 \$(tor-resolve %%h localhost:9050) %%p\n" >> ~/.ssh/config
    else
        printf "\nHost $alias\n\tHostName $target\n\tUser $user\n" >> ~/.ssh/config
        printf "\tCheckHostIP no\n\tCompression yes\n\tProtocol 2\n" >> ~/.ssh/config
        printf "\tProxyCommand connect -4 -S localhost:9050 \$(tor-resolve %%h localhost:9050) %%p\n" >> ~/.ssh/config
    fi

}


if   [[ $1 == "--torify-all"  ]]; then
    printf "\nHost *\n\tCheckHostIP no\n\tCompression yes\n\tProtocol 2\n" >> ~/.ssh/config
    printf "\tProxyCommand connect -4 -S localhost:9050 \$(tor-resolve %%h localhost:9050) %%p\n" >> ~/.ssh/config

elif [[ $1 == "--torify-one"  ]]; then
    torify_one
elif [[ $1 == "--torify-more" ]]; then
    printf "How many connections do you want to torify: "
    read nr
    for(( i=1; i<=nr; i++ ))
    do
        printf "[+]---------------{ $i connection }---------------[+]\n\n"
        torify_one
    done
else
    usage
    exit;
fi
