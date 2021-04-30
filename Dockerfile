FROM google/cloud-sdk:alpine

RUN apk add --upgrade jq
COPY --from=msoap/shell2http /app/shell2http /shell2http
COPY main.sh . 

ENTRYPOINT ["/shell2http","-cgi"]
CMD ["/","/main.sh"]